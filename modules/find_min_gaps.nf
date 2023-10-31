process FIND_MIN_GAPS {
    label 'pandas'
	label 'big_mem'

	publishDir(path: "${publish_dir}/find_min_gaps", mode: "symlink")

	input:
	   path(mafft)

	output:
	   path("${mafft}.longest"), emit: find_min_gaps_ch

	script:
	   '''
	   find_min_gaps.py ${mafft} ${mafft}.longest
	   '''
}
