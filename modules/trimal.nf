process TRIMAL{
    label 'trimal'
    label 'lil_mem'

    publishDir(path: "${params.publish_dir}/publish/trimal", mode: "copy")

    input:
      path(align_nt)
      val(masking_threshold)

    output:
        path("*.masked"), emit: trimal_ch

    script:
        """
        for seq in *fna ; do
            trimal -in \${seq} -out \${seq}.masked -gt ${masking_threshold}
        done
        """
}
