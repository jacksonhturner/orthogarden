process TRIMAL{
    label 'trimal'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/trimal", mode: "symlink")

    input:
      path(translatorx)
      val(masking_threshold)

    output:
        path("*.masked"), emit: trimal_ch

    script:
        """
        for seq in *fasta ; do
            trimal -in \${seq} -out \${seq}.masked -gt ${masking_threshold}
        done
        """
}
