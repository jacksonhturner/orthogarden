import sys
import os
import pandas as pd
import numpy as np

'''
This python scrypt is designed to take a directory of multi-sequence alignments as an input to produce a .csv file demonstrating the completeness of each gene (rows) per taxon (columns) as a percentage.
The resulting file will be pass along to another script to provide a more succinct measure of completeness per taxon.
Completeness is defined in this script as the percentage of base pairs present in a gene per the highest number of base pairs recovered for the gene.

input: directory of aligned nucleotide sequence files (after translatorx), output .csv file
output: csv file demonstrating completeness of each taxon in orthogarden

usage: python3 completeness_table_OG.python directory output.csv
'''

def main():
	seq_path = os.path.abspath(sys.argv[1])
	key_list = []
	for file in os.listdir(seq_path):
		current_path = seq_path + "/" + file
		newvar = exec_dict_i(current_path)
		newlist = newvar.keys()
		key_list += newlist
	key_list = set(key_list)
	key_list = list(filter(None, key_list))
	list_of_rows = []
	row_names = []
	col_names = []
	col_names.append("file_names")
	for item in key_list:
		col_names.append(item)
	for file in os.listdir(seq_path):
		current_path = seq_path + "/" + file
		new_row = []
		new_row = prepare_data_frame(current_path, key_list)
		file_name = new_row[0]
		num_row = new_row
		del num_row[0]
		highest_val = max(num_row)
		if highest_val == 0:
			newnew_row = new_row
		else:
			num_row2 = [i / highest_val for i in num_row]
			newnew_row = []
			newnew_row.append(file_name)
			newnew_row.extend(num_row2)
		rowfile_names = newnew_row[0]
		del newnew_row[0]
		newnewnew_row = []
		newnewnew_row.append(rowfile_names)
		newnewnew_row.append(highest_val)
		newnewnew_row.extend(newnew_row)
		list_of_rows.append(newnewnew_row)
		row_names.append(file)
	col_names = [i.strip('>') for i in col_names]
	col_names = [i.strip('\n') for i in col_names]
	new_col_names = []
	col_names_name = col_names[0]
	del col_names[0]
	new_col_names.append(col_names_name)
	new_col_names.append("max bp")
	new_col_names.extend(col_names)
	df = pd.DataFrame(columns=new_col_names,data=list_of_rows)
	df = df.loc[(df!=0).any(axis=1)]
	df.to_csv(sys.argv[2], sep='\t')

def exec_dict_i(file_name): #get sequence names from each file (and make random dictionary)
	dict_i = {}
	dict_keys = ''
	key_list = ''
	dict_seq = []
	for line in open(file_name):
		if line.startswith(">") and dict_keys == '':
			dict_keys = line.split(' ')[0]
		elif line.startswith(">") and dict_seq != '':
			dict_i[dict_keys] = ''.join(dict_seq)
			dict_keys = line.split(' ')[0]
			dict_seq = []
		else:
			dict_seq.append(line.rstrip())
	dict_i[dict_keys] = ''.join(dict_seq)
	return (dict_i)

def prepare_data_frame(file_name, list_of_keys): #count number of characters in sequence in file
	count_no = []
	count_no.append(file_name)
	with open(file_name) as filename:
		file_lines = filename.readlines()
		for key in list_of_keys:
			if key in file_lines:
				file_slines = iter(open(file_name))
				for row in file_slines:
					if row == key:
						count_no.append(len(next(file_slines)))
			if key not in file_lines:
				count_no.append(0)
	return(count_no)
	
def create_correct_data_frame(data_frame):
	print("yahoo!")

if __name__ == "__main__":
	main()
