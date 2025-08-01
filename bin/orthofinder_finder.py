#!/usr/bin/env python3
import argparse
import math
import numpy as np
import os
import pandas as pd
import sys

'''
given orthofinder results, parse the orthogroups for those nearly
single-copy genes

note: naming prefix must be identical between augustus codingseq files
      and the .faa sequences used by OrthoFinder

input:
sys.argv[1] : results directory of OrthoFinder
sys.argv[2] : percent (0 < x < 1) of taxa with single copies per group
sys.argv[3] : directory with augustus files ending in "codingseq" and "faa"
sys.argv[4] : output directory
sys.argv[5] : limit output to n top scg_freq orthogroups (int; 0 for all)

overview:
[x] open orthogroup count summary file
[x] subset the orthogroups to those present in _ percent of taxa as SCG
[x] create empty output files per orthogroup
[x] per taxon, create a dictionary of orthogroup names : gene names
[x] open augustus codingseq file (colname) and iterate lines until find
    the corresponding sequence name in header (check vs dict keys, val
    is the output); append output OG file
'''

def parse_user_input():
    parser = argparse.ArgumentParser(description='')

    parser.add_argument('-d', '--ogdir', type=str, required=True,
                        help='results directory of OrthoFinder')

    parser.add_argument('-t', '--threshold', type=float, required=False,
                        default=0.33,
                        help='minimum percent (0 < x < 1) of taxa with single copies per group')

    parser.add_argument('-s', '--seqdir', type=str, required=True,
                        help='directory with augustus files ending in codingseq and faa')

    parser.add_argument('-o', '--outdir', type=str, required=True,
                        help='directory for output')

    parser.add_argument('-l', '--limit_ogs', type=int, required=False,
                        default=0,
                        help='limit orthogroup results to n orthogroups based on threshold')

    args = parser.parse_args()

    return args


def check_inputs(args):
    if not os.path.exists(args.ogdir):
        sys.exit(f'could not find {args.ogdir}')
    if not 0 < float(args.threshold) <= 1:
        sys.exit(f'{args.threshold} not between 0 and 1')
    if not os.path.exists(args.seqdir):
        sys.exit(f'could not find {args.seqdir}')
    if not os.path.exists(args.outdir):
        sys.exit(f'could not find {args.outdir}')
    else:
        if len(os.listdir(args.outdir)) > 0:
            sys.exit("output directory should be empty")


def get_orthofinder_path(args):
    '''
    assumes standard OrthoFinder results directory structure
    '''
    count_file = os.path.join(args.ogdir,
                              "Orthogroups",
                              "Orthogroups.GeneCount.tsv")
    group_file = os.path.join(args.ogdir,
                              "Orthogroups",
                              "Orthogroups.tsv")
    return count_file, group_file


def get_df_nice(input_file):
    '''
    load the orthogroup gene counts matrix
    use orthogroup as row name
    drop the total column for ease of calculations
    '''
    df = pd.read_csv(input_file, sep='\t')
    df = df.set_index("Orthogroup")
    return df


def add_columns(df):
    '''
    add the following summary columns:
    scg_freq    count the frequency of single copy genes per orthogroup
    freq        the frequency of the orthogroup, regardless of number
                (presence/abscense)
    '''
    df["freq"] = df.apply(lambda row: (row != 0).sum(), axis=1)
    df["scg_freq"] = df.apply(lambda row: (row == 1).sum(), axis=1)
    df = df.sort_values(by=["scg_freq"], ascending=False)

    return df


def limit_ogs(args, df, taxa_names):
    """
    if limit_ogs is set to 0, return all taxa above the threshold, else
    iterate over the threshold descending from 1 until limit_ogs n is
    achieved

    if limit_ogs not achieved in iteration, return the last tmp_df in
    the acceptable threshold range
    """
    taxa_freq = float(args.threshold) * len(taxa_names)
    if args.limit_ogs == 0:
        df = df.query("scg_freq >= @taxa_freq")
        print(f"using {df.shape[0]} orthogroups")
        return df
    elif args.threshold == 1:
        df = df.query("scg_freq >= @taxa_freq")
        print(f"using {df.shape[0]} orthogroups")
        return df

    for threshold in np.arange(1, args.threshold-0.01, -0.01):
        threshold = round(threshold, 2)
        taxa_freq = float(threshold) * len(taxa_names)
        tmp_df = df.query("scg_freq >= @taxa_freq")
        print(f"searching scg threshold {threshold} found {tmp_df.shape[0]} scg orthogroups")
        if tmp_df.shape[0] >= args.limit_ogs:
            args.threshold = threshold
            print(f"using {args.limit_ogs} of {tmp_df.shape[0]} orthogroups")
            return tmp_df.head(int(args.limit_ogs))

    print(f"using {tmp_df.shape[0]} orthogroups")
    return tmp_df


def touch_orthogroup_files(args, group_ls):
    '''
    create empty files to append with the orthogroup sequences
    '''
    for group in group_ls:
        outfile = os.path.join(args.outdir, f'{group}.fa')
        open(outfile, 'a').close()


def get_codingseqs(group_df, taxa_names):
    '''
    for each taxon, make a dictionary of each orthogroup and the
    corresponding sequence names
    '''
    for taxon in taxa_names:
        print(taxon)
        group_dt = dict(zip(group_df.index, group_df[taxon]))
        group_dt = format_dictionary(group_dt)
        search_codingseqs(args, taxon, group_dt)


def format_dictionary(group_dt):
    '''
    some values will be nan -> remove these
    some sequence fields will have multiple sequences -> convert to list
    keep only single copy genes and reverse key : value order
    '''
    new_dt = {}
    for group, seqs in group_dt.items():
        try:
            if math.isnan(seqs):
                continue
        except TypeError:
            seq_ls = seqs.split(", ")
            #TODO hypothetically add multi OG testing here
            if len(seq_ls) == 1:
                new_dt[seq_ls[0]] = group
    return new_dt


def search_codingseqs(args, taxon, group_dt):
    '''
    open the codingseq file for a taxon
    iterate the fasta sequences looking for the sequences in group_dt
    '''
    with open(os.path.join(args.seqdir, f'{taxon}.codingseq')) as f:
        parse_codingseq(args, f, group_dt, taxon)
    with open(os.path.join(args.seqdir, f'{taxon}.faa')) as f:
        parse_faa(args, f, group_dt, taxon)


def parse_codingseq(args, f, group_dt, taxon):
    '''
    iterate lines of open fasta file
    if header, check if the header info is in group_dt values
    '''
    seq = ''
    for line in f:
        if line.startswith(">"):
            if seq:
                write_to_orthogroup(args, taxon, seq, group, "fna")
            seq = ''
            line = '.'.join(line.rstrip().split('.')[-2:])
            if not line.startswith('g'):
                sys.exit('unexpected formatting from Augustus output')
            if line in group_dt:
                add_to_seq = True
                group = group_dt[line]
            else:
                add_to_seq = False
        elif add_to_seq:
            seq += line.rstrip()
        else:
            continue
    if seq:
        write_to_orthogroup(args, taxon, seq, group, "fna")


def parse_faa(args, f, group_dt, taxon):
    '''
    iterate lines of open fasta file
    if header, check if the header info is in group_dt values
    '''
    seq = ''
    for line in f:
        if line.startswith(">"):
            if seq:
                write_to_orthogroup(args, taxon, seq, group, "faa")
            seq = ''
            line = line.rstrip()[1:]
            if not line.startswith('g'):
                sys.exit('unexpected formatting from Augustus output')
            if line in group_dt:
                add_to_seq = True
                group = group_dt[line]
            else:
                add_to_seq = False
        elif add_to_seq:
            seq += line.rstrip()
        else:
            continue

    if seq:
        write_to_orthogroup(args, taxon, seq, group, "faa")


def write_to_orthogroup(args, taxon, seq, group, suffix):
    with open(os.path.join(args.outdir, f'{group}.{suffix}'), 'a') as o:
        o.write(f'>{taxon}\n')
        o.write(f'{seq}\n')


def main(args):
    check_inputs(args)
    count_file, group_file = get_orthofinder_path(args)
    df = get_df_nice(count_file)
    df = df.drop("Total", axis=1)
    taxa_names = df.columns.to_list()
    df = add_columns(df)
    df = limit_ogs(args, df, taxa_names)
    df.to_csv(os.path.join(args.outdir, f"off_narrowed_{100*float(args.threshold)}.csv"))
    touch_orthogroup_files(args, df.index.to_list())
    group_df = get_df_nice(group_file)
    group_df = group_df[group_df.index.isin(df.index.to_list())]
    get_codingseqs(group_df, taxa_names)


if __name__ == "__main__":
    args = parse_user_input()
    main(args)

