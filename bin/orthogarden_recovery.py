#!usr/bin/env python3
import sys
import pandas as pd
import math

def main():
        new_df = make_new_df(sys.argv[1])
        target_df = get_bad_taxa(new_df)
        print(target_df)

def make_new_df(a):
        df = pd.read_csv(a)
        df = df.iloc[:, :-2]

        df_max = df.max(numeric_only=True).max()

        replace_these = []

        for i in range(1, df_max+1):
                replace_these.append(i)

        new_df = df.replace(to_replace = replace_these,value="NA")
        new_df = new_df.replace(to_replace = 0,value=1)
        new_df = new_df.replace(to_replace = "NA",value=0)

        return new_df

def get_bad_taxa(b):

        '''
        INPUT: new_df
        OUTPUT: df of bad taxa and missing OGs (target_df)

        [x] count number of OGs per column (taxon) and turn it into a list
        [x] identify threshold (max value/3, rounded up)
        [x] make new df with rows
        [x] keep only columns of new_df that are columns in newer_df

        '''

        new_df = b
        scg_freq = new_df.apply(lambda column: (column == 1).sum(), axis=0)
        scg_freq = scg_freq.sort_values(ascending=False)

        scg_max = scg_freq.max(numeric_only=True).max()
        threshold = math.ceil(scg_max/3)
        newer_df = scg_freq[scg_freq > threshold]
        newer_df = newer_df.to_frame()
        newer_df = newer_df.T

        target_df = new_df[new_df.columns.intersection(newer_df.columns)]
        return target_df

if __name__ == "__main__":
        main()
