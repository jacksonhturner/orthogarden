process TRANSLATORX {
    label 'translatorx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/translatorx", mode: "symlink")

    input:
        tuple val(ortho_id), path(ortho_nucl), path(pasta)

    output:
        path("${id}*nt_*), emit: pasta_ch

    script:
        """
        perl translatorx.pl -i ${id}.fasta -a ${id}.aa -o ${id}.nt.aligned
        """
}
