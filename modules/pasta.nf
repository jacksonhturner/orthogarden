process PRE_PASTA{
    label 'lil_mem'
    
    publishDir(path: "${publish_dir}/pre_pasta", mode: "symlink")

    input:
       path(seqkit_aa)

    output:
       path("${seqkit_aa}.cleaned"), emit: pre_pasta_ch

    script:
        """
	python_replace.py ${seqkit_aa} '*' N ${seqkit_aa}.cleaned
	"""
}

process PASTA{
    label 'pasta'
    label 'mafft'
    label 'big_mem'
    
    publishDir(path: "${publish_dir}/pasta", mode: "symlink")

    input:
        path(pre_pasta_aa)
        
    output:
        path("${pre_pasta_aa}.pasta/*marker001*"), emit: pasta_ch

    script:
        """
        run_pasta.py \
        -i ${pre_pasta_aa} \
        -j ${pre_pasta_aa} \
        -o ${pre_pasta_aa}.pasta \
        -d Protein \
        --max-mem-mb 2048
        """
}
