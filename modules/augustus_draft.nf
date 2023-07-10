process AUGUSTUS {
    label 'augustus'

    publishDir(path: "${publish_dir}/augustus", mode:softlink)

    input:
        tuple val(id), path(masurca)
        val augustus_ref

    output:
        tuple val(id), path("augustus_$id"/${id}.aa), path("augustus_$id"/${id}.cds), emit: augustus_ch

     script:
        """
        mkdir augustus_$id
        augustus --codingseq=on --species=${augustus_ref} ${masurca} > ${id}.gff
        getAnnoFasta ${id}.gff
        """
}
