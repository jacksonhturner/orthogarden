#!/usr/bin/env python3
import argparse
import math
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import sys

'''
given orthofinder results, parse the orthogroups for those nearly
single-copy genes

note: naming prefix must be identical between augustus codingseq files
      and the .faa sequences used by OrthoFinder

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

    parser.add_argument('-s', '--seqdir', type=str, required=True,
                        help='directory with augustus files ending in codingseq and faa')

    parser.add_argument('-o', '--outdir', type=str, required=True,
                        help='directory for output')

    args = parser.parse_args()

    return args


def check_inputs(args):
    if not os.path.exists(args.ogdir):
        sys.exit(f'could not find {args.ogdir}')
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
    count_ls = []
    thresh_ls = []

    for idx, threshold in enumerate(np.arange(1, -0.01, -0.01)):
        threshold = round(threshold, 2)
        taxa_freq = float(threshold) * len(taxa_names)
        tmp_df = df.query("scg_freq >= @taxa_freq")
        scg_count = tmp_df.shape[0]

        print(f"searching scg threshold {threshold} found {tmp_df.shape[0]} scg orthogroups")

        if idx == 0:
            thresh_ls.append(threshold)
            count_ls.append(scg_count)
        elif scg_count != count_ls[-1]:
            thresh_ls.append(threshold)
            count_ls.append(scg_count)

    return thresh_ls, count_ls


def plot_thresh_by_count(args, thresh_ls, count_ls):
    # plt.style.use('seaborn-v0_8-darkgrid')
    # plt.style.use('bmh')
    # plt.style.use('seaborn-v0_8-white')
    plt.style.use('ggplot')

    plt.figure(figsize=(10, 6), dpi=300)
    plt.plot(count_ls, thresh_ls)
    plt.xlabel('Orthogroups')
    plt.ylabel('Percent SCG')
    plt.savefig(os.path.join(args.outdir, "scg_plot.png"))

    df = pd.DataFrame({'count': count_ls, 'scg_threshold': thresh_ls})
    df.to_csv(os.path.join(args.outdir, "count_by_threshold.csv"), index=False)


def main(args):
    check_inputs(args)
    count_file, group_file = get_orthofinder_path(args)
    df = get_df_nice(count_file)
    df = df.drop("Total", axis=1)
    taxa_names = df.columns.to_list()
    df = add_columns(df)
    thresh_ls, count_ls = limit_ogs(args, df, taxa_names)
    plot_thresh_by_count(args, thresh_ls, count_ls)


if __name__ == "__main__":
    args = parse_user_input()
    main(args)

