process PARSE_METADATA {
    label 'pandas'

    publishDir "${publish_dir}/design", mode: 'copy'

    input:
        path design

    output:
        path 'reads.csv', emit: reads_csv
        path 'fasta.csv', emit: fasta_csv

    script:
        """
        parse_design.py \
            ${design}
        """
}

process READS_TO_CH {
    
    input:
        path reads_csv

    output:
        ch_reads_raw
    
    Channel
    .fromPath( reads_csv )
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( row.id, file(row.r1), file(row.r2) ) }
    .set { ch_reads_raw }
}