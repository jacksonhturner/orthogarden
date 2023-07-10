process MASURCA {
    // draft ///

    publishDir(path: "${publish_dir}/masurca", mode:softlink)

    input:
        tuple val(id), path(kraken.r1), path(kraken.r2)

    output:
        path("masurca_${id}"), emit: masurca_ch

    script:
        """
        mkdir masurca_$id
        masurca -i ${kraken.r1} ${kraken.r2} \
        -o masurca_${id}
        """
}
