process PARSE_METADATA {
    label 'pandas'
    label 'lil_mem'

    publishDir "${publish_dir}/design", mode: 'copy'

    input:
        path design

    output:
        path 'reads.csv', emit: reads_csv
        path 'fasta.csv', emit: fasta_csv
        path 'augustus.csv', emit: augustus_csv

    script:
        """
        parse_design.py \
            ${design}
        """
}
