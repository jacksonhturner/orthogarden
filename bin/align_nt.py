#!/usr/bin/env python3

import sys


aa_dt = {"ATT" : "I",
         "ATC" : "I",
         "ATA" : "I",
         "CTT" : "L",
         "CTC" : "L",
         "CTA" : "L",
         "CTG" : "L",
         "TTA" : "L",
         "TTG" : "L",
         "GTT" : "V",
         "GTC" : "V",
         "GTA" : "V",
         "GTG" : "V",
         "TTT" : "F",
         "TTC" : "F",
         "ATG" : "M",
         "TGT" : "C",
         "TGC" : "C",
         "GCT" : "A",
         "GCC" : "A",
         "GCA" : "A",
         "GCG" : "A",
         "GGT" : "G",
         "GGC" : "G",
         "GGA" : "G",
         "GGG" : "G",
         "CCT" : "P",
         "CCC" : "P",
         "CCA" : "P",
         "CCG" : "P",
         "ACT" : "T",
         "ACC" : "T",
         "ACA" : "T",
         "ACG" : "T",
         "TCT" : "S",
         "TCC" : "S",
         "TCA" : "S",
         "TCG" : "S",
         "AGT" : "S",
         "AGC" : "S",
         "TAT" : "Y",
         "TAC" : "Y",
         "TGG" : "W",
         "CAA" : "Q",
         "CAG" : "Q",
         "AAT" : "N",
         "AAC" : "N",
         "CAT" : "H",
         "CAC" : "H",
         "GAA" : "E",
         "GAG" : "E",
         "GAT" : "D",
         "GAC" : "D",
         "AAA" : "K",
         "AAG" : "K",
         "CGT" : "R",
         "CGC" : "R",
         "CGA" : "R",
         "CGG" : "R",
         "AGA" : "R",
         "AGG" : "R",
         "TAA" : "X",
         "TAG" : "X",
         "TGA" : "X"}


def get_sequence(fasta):
    fasta_dt = {}
    seq = ""
    with open(fasta) as f:
        for line in f:
            if line.startswith(">") and not seq:
                header = line.rstrip()[1:]
            elif line.startswith(">") and seq:
                fasta_dt[header] = seq
                header = line.rstrip()[1:]
                seq = ""
            else:
                seq += line.rstrip()

    fasta_dt[header] = seq
    return fasta_dt


def align_nt_to_mafft(m_seq, f_seq):
    print(m_seq)
    print(f_seq)
    result = ""
    f_pos = 0
    for m in m_seq:
        if m == "-":
            result += "---"
        else:
            if not m == aa_dt[f_seq[f_pos:f_pos+3]]:
                sys.exit("f_seq")
            else:
                result += f_seq[f_pos:f_pos+3]
            f_pos += 3
    return result


def main():
    mafft = sys.argv[1]
    fix_frames = sys.argv[2]
    out_name = sys.argv[3]

    mafft_dt = get_sequence(mafft)
    frame_dt = get_sequence(fix_frames)

    with open(out_name, "w") as o:
        for k, v in mafft_dt.items():
            result = align_nt_to_mafft(v, frame_dt[k])
            o.write(f">{k}\n")
            o.write(f"{result}\n")


if __name__ == "__main__":
    main()

