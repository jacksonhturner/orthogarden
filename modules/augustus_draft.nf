process AUGUSTUS {
    label 'augustus'

    publishDir(path: "${publish_dir}/augustus", mode:softlink)

    input:
        tuple val(id), path(masurca)
        val augustus_ref

    output:
        path("augustus_$id"/${id}.gff), emit: augustus_ch

     script:
        """
        mkdir augustus_$id
        augustus --codingseq=on --species=${augustus_ref} ${masurca} > ${id}.gff
        """
}
