#!/usr/bin/env python3
import math
import sys

'''
converts a nucleotide sequence to ambiguous third positions ('N')
saves fasta with line lengths of 100bp

sys.argv[1] is the fasta file to filter by sequence length
sys.argv[2] is the name of the output file
'''


def split_seq_to_lines(seq):
    split_seq = ''
    for i in range(math.ceil(len(seq) / 100)):
        split_seq = split_seq + seq[i*100:(i*100)+100] + '\n'
    return split_seq


def change_thirds(seq):
    third_seq = ''
    for idx, base in enumerate(seq):
        if (idx+1) % 3 == 0:
            third_seq += 'N'
        else:
            third_seq += base
    return third_seq


with open(sys.argv[1]) as f, open(sys.argv[2], 'w') as o:
    seq = ''
    for idx, line in enumerate(f):
        if line.startswith('>'):
            if idx > 0:
                third_seq = change_thirds(seq)
                split_seq = split_seq_to_lines(third_seq)
                o.write(header)
                o.write(split_seq)
            header = line
            seq = ''
        else:
            seq += line.rstrip()

    third_seq = change_thirds(seq)
    split_seq = split_seq_to_lines(third_seq)
    o.write(header)
    o.write(split_seq)




