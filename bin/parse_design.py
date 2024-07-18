#!/usr/bin/env python3

import pandas as pd
import sys


def check_columns(df):
    '''
    make sure only expected columns present
    '''
    expected_cols = ['id', 'r1', 'r2', 'ref', 'augustus']
    for i in df.columns:
        assert i in expected_cols


def check_reads(df):
    '''
    make sure r1 AND r2 present
    '''
    r1_true = df['r1'].notna().to_list()
    r2_true = df['r2'].notna().to_list()
    assert r1_true == r2_true, "only paired-end data is supported"


def check_fasta(df):
    '''
    make fasta only present when no r1/r2
    '''
    r1_true = df['r1'].notna().to_list()
    ref_true = df['ref'].isna().to_list()
    assert r1_true == ref_true, "input must be reads OR reference"


def check_samples(df):
    '''
    make sure sample id is present with something
    '''
    assert df['id'].isna().sum() == 0, "missing sample id(s)"


df = pd.read_csv(sys.argv[1])
check_columns(df)
check_reads(df)
check_fasta(df)
check_samples(df)

df_reads = df[df['r1'].notna()]
df_reads = df_reads[['id', 'r1', 'r2', 'augustus']]
df_reads.to_csv('reads.csv', index=False)

df_fasta = df[df['ref'].notna()]
df_fasta = df_fasta[['id', 'ref', 'augustus']]
df_fasta.to_csv('fasta.csv', index=False)
