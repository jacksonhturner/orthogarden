process TRANSLATORX {
    label 'translatorx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/translatorx", mode: "symlink")

    input:
        path(ortho_nucl)
        path(ortho_aligned_aa)

    output:
        path("${ortho_id}.mapped.fa"), emit: translatorx_ch

    script:
        ortho_id = ortho_aligned_aa.name.split('.')[0]
        """
        translatorx.pl -i "${ortho_id}.fa" -a "${ortho_id}.aa.cleaned.mafft" -o "${ortho_id}.mapped.fa"
        """
}
