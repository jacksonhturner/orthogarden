process TRIMAL{
    label 'trimal'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/trimal", mode: "symlink")

    input:
      path(translatorx)
      val(masking_threshold)

    output:
        path("${translatorx}.masked"), emit: trimal_ch

    script:
        """
        trimal -in ${translatorx} -out ${translatorx}.masked -gt ${masking_threshold}
        """
}
