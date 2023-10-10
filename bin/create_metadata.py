import os
import pandas as pd
import sys


'''
sys.argv[1] is a directory containing only fastq (pe or se) and fasta files
'''


def main():
    seq_path = os.path.abspath(sys.argv[1])
    fq_file_dt = {}
    fa_file_dt = {}

    suffix_ls = [".fa",    ".fa.gz",
                 ".fasta", ".fasta.gz",
                 ".fastq", ".fastq.gz",
                 ".fna",   ".fna.gz",
                 ".fq",    ".fq.gz"]

    for seq_file in os.listdir(seq_path):
        seq_file_pre, seq_type = check_suffix(seq_file, suffix_ls)
        if seq_type == "fq":
            if seq_file_pre in fq_file_dt.values():
                sys.exit(f"{seq_file_pre} name used more than once")
            else:
                fq_file_dt[seq_file] = seq_file_pre
        else:
            fa_file_dt[seq_file] = seq_file_pre
    files_ls = check_for_pairs(seq_path, fq_file_dt)
    files_ls = add_fasta_files(seq_path, fa_file_dt, files_ls)

    df = pd.DataFrame(files_ls, columns = ["id", "r1", "r2", "ref"])
    df.to_csv("metadata.csv", index=None)



def check_suffix(seq_file, suffix_ls):
    '''
    check if file ends with accepted suffix, else exit with error
    '''
    for suffix in suffix_ls:
        if seq_file.endswith(suffix):
            if "q" in suffix:
                return seq_file[:-len(suffix)], "fq"
            else:
                return seq_file[:-len(suffix)], "fa"

    sys.exit(f"{seq_file} has unexpected suffix")


def check_for_pairs(seq_path, fq_file_dt):
    files_ls = []
    prefix_names = list(fq_file_dt.values())

    for k, v in fq_file_dt.items():
        if v.endswith("1") and f"{v[:-1]}2" in prefix_names:
            name = strip_chars(v)
            r1 = os.path.join(seq_path, k)
            r2 = os.path.join(seq_path,f"{v[:-1]}2{k[len(v):]}")
            files_ls.append([name, r1, r2, None])
        elif v.endswith("2") and f"{v[:-1]}1" in prefix_names:
            continue
        else:
            r1 = os.path.join(seq_path, k)
            files_ls.append([v, r1, None, None])

    return files_ls


def strip_chars(v):
    strip_ls = ["_1", ".1", ".R1", "_R1"]
    for i in strip_ls:
        if v.endswith(i):
            return v[:-len(i)]

    sys.exit(f"unexpected characters before 1 in {v}, expected _/./.R/_R")


def add_fasta_files(seq_path, fa_file_dt, files_ls):
    for k, v in fa_file_dt.items():
        files_ls.append([v, None, None, os.path.join(seq_path, k)])

    return files_ls


if __name__ == "__main__":
    main()
