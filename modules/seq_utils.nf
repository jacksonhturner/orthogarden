process FIX_FRAMES {
    label 'pandas'
    label 'lil_mem'

    // publishDir "${publish_dir}/design", mode: 'copy'

    input:
        path(proteins)
        path(codingseqs)

    output:
        path("*.fa"), emit: fixed_ch 

    script:
        """
        for prot in *.faa ; do
            frame_check.py \
                \$prot \
                \${prot%%faa}fna
        done
        """
}

process REMOVE_THIRDS {
    label "pandas"
    label "lil_mem"

    publishDir(path: "${publish_dir}/remove_thirds", mode: "copy")

    input: 
        path(trimal)

    output:
        path("*.no3rds"), emit: remove_thirds_ch

    script:
        """
        for trimal in *.masked ; do
            pull_third_pos.py \${trimal} \${trimal}.no3rds
        done
        """
}
