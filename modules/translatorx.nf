process TRANSLATORX {
    label 'translatorx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/translatorx", mode: "symlink")

    input:
        tuple path(ortho_nucl), path(ortho_aligned_aa)

    output:
        path("${ortho_nucl.baseName}.mapped.nt_ali.fasta"), emit: translatorx_ch

    script:
        """
        translatorx.pl -i ${ortho_nucl} -a ${ortho_aligned_aa} -o ${ortho_nucl.baseName}.mapped
        """
}
