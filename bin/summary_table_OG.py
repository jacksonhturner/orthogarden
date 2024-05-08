#!/usr/bin/env python
import gzip
import pandas as pd
import sys


'''
This script is designed to take the .csv file generated by completeness_table_OG.py and convert it to a more succinct, summary table.

inputs: .csv file percentage of genes recovered by taxon
outputs: .csv summary file

usage: summary_table_OG.py in.csv out.csv
'''


def main():
	csv_in = sys.argv[1]

	df = pd.read_csv(csv_in, sep="\t", header=None)
	df = pd.DataFrame(df)
	df = df.fillna(0)
	df = df.iloc[:, 1:]
	col_names = df.iloc[0]
	#row_names = df.iloc[:, 0]
	df.columns = col_names
	#df.index.names = row_names
	df = df.iloc[1:, :]
	col_names = col_names.tolist()
	#print (col_names)

	fin_present = []
	fin_absent = []
	fin_ninety_percent = []
	fin_seventyfive_percent = []
	fin_fifty_percent = []
	fin_twentyfive_percent = []
	fin_ten_percent = []

	for i in col_names[1:]:

		present = 0
		present = 0
		absent = 0
		absent = 0
		ninety_percent = 0
		seventyfive_percent = 0
		fifty_percent = 0
		twentyfive_percent = 0
		ten_percent = 0

		for x in df[i]:

			x = float(x)
			if x > 0:
				present += 1
			if x == 0:
				absent += 1
			if x > 0.9:
				ninety_percent += 1
			if x > 0.75:
				seventyfive_percent += 1
			if x > 0.5:
				fifty_percent += 1
			if x > 0.25:
				twentyfive_percent += 1
			if x > 0.1:
				ten_percent += 1

		fin_present.append(present)
		fin_absent.append(absent)
		fin_ninety_percent.append(ninety_percent)
		fin_seventyfive_percent.append(seventyfive_percent)
		fin_fifty_percent.append(fifty_percent)
		fin_twentyfive_percent.append(twentyfive_percent)
		fin_ten_percent.append(ten_percent)

	dict = {'taxon': col_names[1:], 'present': fin_present, 'absent': fin_absent, '90%': fin_ninety_percent, '75%': fin_seventyfive_percent, '50%': fin_fifty_percent, '25%': fin_twentyfive_percent, '10%': fin_ten_percent}

	new_df = pd.DataFrame(dict)
	new_df.to_csv(sys.argv[2], sep='\t')

if __name__ == "__main__":
        main()
