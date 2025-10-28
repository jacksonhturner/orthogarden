process PRE_MAFFT{
    label 'pandas'
    label 'lil_mem'
    
    publishDir(path: "${params.publish_dir}/publish/mafft", mode: "symlink")

    input:
       path(seqkit_aa)

    output:
       path("*.cleaned"), emit: pre_mafft_ch

    script:
        """
        for prot in *aa; do
	        python_replace.py \${prot} '*' N \${prot}.cleaned
        done
	    """
}

process MAFFT{
    label 'mafft'
    label 'big_mem'
    
    publishDir(path: "${params.publish_dir}/publish/mafft", mode: "copy")

    input:
        path(augustus_aa)

    output:
        path("*.mafft"), emit: mafft_ch

    script:
        """
        for prot in ./*aa ; do
            nwnsi --amino \${prot} > \${prot}.mafft
        done
        """
}

process OLD_MAFFT{
    label 'mafft'
    label 'big_mem'
    
    publishDir(path: "${params.publish_dir}/publish/mafft", mode: "symlink")

    input:
        tuple path(pre_mafft_fa), path(pre_mafft_aa)

    output:
        tuple path(pre_mafft_fa), path("${pre_mafft_aa}.mafft"), emit: mafft_ch

    script:
        """
        nwnsi ${pre_mafft_aa} > ${pre_mafft_aa}.mafft
        """
}
