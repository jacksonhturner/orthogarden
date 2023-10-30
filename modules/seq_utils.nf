
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
        frame_check.py \
            ${proteins}
            ${codingseqs}
        """
}
