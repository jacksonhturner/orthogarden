import gzip
import pandas as pd
import sys


'''
sys.argv[1] is tsv
sys.argv[2] is R1
'''


def main():
    tsv = sys.argv[1]
    r1  = sys.argv[2]

    df = pd.read_csv(tsv, sep='\t', header=None)
    make_empty_reads(df[1].unique())
    read_dt = read_dictionary(df)
    compressed = gzip_test(r1)
    open_reads(r1, read_dt, compressed)


def make_empty_reads(og_ls):
    for og in og_ls:
        with open(f"{og}_R1.fq", 'w'):
            pass


def read_dictionary(df):
    read_dt = {}
    for read_name, og in zip(df[0].to_list(), df[1].to_list()):
        if read_name in read_dt:
            read_dt[read_name].append(og)
        else:
            read_dt[read_name] = [og]
    return read_dt


def gzip_test(r1):
    '''
    test if fastq r1 is gzipped (assumed true for r2)
    '''
    try:
        with open(r1) as f:
            f.readline()
        return False
    except UnicodeDecodeError:
        return True


def open_reads(r1, read_dt, compressed):
    '''
    if compressed decompress using context manager
    send f1, f2 to iterate_reads
    '''
    if compressed:
        with gzip.open(r1, 'rt') as f1:
            iterate_reads(f1, read_dt)
    else:
        with open(r1) as f1:
            iterate_reads(f1, read_dt)


def iterate_reads(f1, read_dt):
    write_line = False

    for idx, (line1) in enumerate(f1):
        if (idx + 4) % 4 == 0:
            if write_line:
                write_to_file(seq1, og_ls)
            write_line = False
            seq1 = ""
            
            # test the header for presence in dictionary
            read_name = line1.split()[0][1:]
            if read_name in read_dt:
                og_ls = read_dt[read_name]
                write_line = True

        if write_line is True:
            seq1 += line1

    if write_line:
        write_to_file(seq1, og_ls)


def write_to_file(seq1, og_ls):
    for og in og_ls:
        with open(f"{og}_R1.fq", 'a') as f1:
            f1.write(seq1)


if __name__ == "__main__":
    main()


'''
- [x] open df
- [x] get list of all unique OGs
- [x] create dictionary from columns where values can be a list of OGs
- [x] write 'w' version of all OGs (empty, but overwrite prev attempts)
- [x] test if fq files are gzipped
- [x] open fq files
- [x] iterate over fq files
- [x] get header
- [x] check for header in keys of dictionary
- [x] if present, get header/seq/+/scores as read
- [x] write function to temporarily open OG file and append read
'''

