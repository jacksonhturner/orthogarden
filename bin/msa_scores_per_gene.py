import sys
import os
import pandas as pd
import statistics as st

'''
This python script is designed to generate a .csv file from a set of scored multi sequence alignments generated with './mstatx -i aln.fasta -s trident -o out.fasta' with the position labels and tab characters already removed.
This script is written in hopes to identify poorly-aligned and highly divergent multi sequence alignments, from which loci unique to respective taxa may be identified.
Higher scores (approaching 1) represent better alignments and worse scores (approaching 0) represent worse alignments.

input: directory with mstatx scores (see above) with the position labels and tab characters removed
output: .csv fle with two columns, one for gene names and one for the mean alignment score

usage: python3 msa_scores_per_gene.py directory/ output.csv
'''

def main():
	seq_path = os.path.abspath(sys.argv[1])
	key_list = []
	mean_score = []
	for file in os.listdir(seq_path):
		current_path = seq_path + "/" + file
		file_name = str(file)
		key_list.append(file_name)
		list_of_lines = open(file).readlines()
		list_of_lines = ([line.replace('\n', '') for line in list_of_lines])
		list_of_lines = list(map(float, list_of_lines))
		sum_lines = 0
		for element in list_of_lines:
			sum_lines += element
		current_mean_score = sum_lines / len(list_of_lines)
		current_mean_score = str(current_mean_score)
		mean_score.append(current_mean_score)
	dict = {'gene name' : key_list, 'mean alignment score' : mean_score}
	df = pd.DataFrame(dict)
	df.to_csv(sys.argv[2], sep = '\t')

if __name__ == "__main__":
        main()
