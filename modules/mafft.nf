process PRE_MAFFT{
    label 'lil_mem'
    
    publishDir(path: "${publish_dir}/mafft", mode: "symlink")

    input:
       tuple path(seqkit_fa), path(seqkit_aa)

    output:
       tuple path(seqkit_fa), path("${seqkit_aa}.cleaned"), emit: pre_mafft_ch

    script:
        """
	    python_replace.py ${seqkit_aa} '*' N ${seqkit_aa}.cleaned
	    """
}

process MAFFT{
    label 'mafft'
    label 'big_mem'
    
    publishDir(path: "${publish_dir}/mafft", mode: "symlink")

    input:
        tuple path(pre_mafft_fa), path(pre_mafft_aa)
        
    output:
        tuple path(pre_mafft_fa), path("${pre_mafft_aa}.mafft"), emit: mafft_ch

    script:
        """
        nwnsi ${pre_mafft_aa} > ${pre_mafft_aa}.mafft
        """
}
