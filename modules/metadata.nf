process PARSE_METADATA {
    label 'pandas'

    publishDir "${publish_dir}/design", mode: 'copy'

    input:
        path design

    output:
        path '*.csv', emit: csv

    script:
        """
        parse_design.py \
            ${design}
        """
}