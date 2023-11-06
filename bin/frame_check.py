#!/usr/bin/env python3
import os
import sys


'''
sys.argv[1] is faa file
sys.argv[2] is fna file
'''


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


def main():
    base = os.path.basename(sys.argv[1])[:-4]
    with open(sys.argv[1]) as faa, open(sys.argv[2]) as fna, open(f"{base}.fa", "w") as o:
        for prot, codingseq in zip(faa, fna):
            codingseq = codingseq.rstrip()
            prot = prot.rstrip()
            if prot.startswith(">"):
                assert(prot == codingseq)
            else:
                codingseq = find_frame(codingseq, prot)
            o.write(codingseq + "\n")


def find_frame(codingseq, prot):
    codingseq = codingseq.upper()
    a, b, c = "", "", ""
    for pos, base in enumerate(codingseq[:-2]):
        frame = codingseq[pos:pos+3]
        try:
            aa = aa_dt[frame]
        except KeyError:
            aa = "X"
        if pos%3 == 0:
            a += aa
        if pos%3 == 1:
            b += aa
        if pos%3 == 2:
            c += aa

    if prot in a:
        return codingseq[:len(prot)*3]
    if prot in b:
        return codingseq[1:1+len(prot)*3]
    if prot in c:
        return codingseq[2:2+len(prot)*3]
    else:
        print(prot)
        print(a)
        print(b)
        print(c)
        sys.exit("OH NO")


if __name__ == "__main__":
    main()
