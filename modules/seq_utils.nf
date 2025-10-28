process FIX_FRAMES {
    label 'pandas'
    label 'lil_mem'

    // publishDir "${params.publish_dir}/publish/design", mode: 'copy'

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

    publishDir(path: "${params.publish_dir}/publish/remove_thirds", mode: "copy")

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

process ALIGN_NT {
    label 'pandas'
    label 'lil_mem'

    publishDir(path: "${params.publish_dir}/publish/align_nt", mode: "copy")

    input:
        path(combined_ch)

    output:
        path("*.align_nt.fna"), emit: align_nt_ch

    script:
        """
        for prot in ./*faa.mafft ; do
            align_nt.py \${prot} \${prot%%faa.mafft}fa \${prot%%faa.mafft}align_nt.fna
        done
        """
}
