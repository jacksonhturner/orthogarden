process TRIMAL{
    label 'trimal'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/trimal", mode: "symlink")

    input:
      tuple val(ortho_id), path(translatorx)
      val(masking_threshold)

    output:
        path("${id}_masked.fasta"), emit: trimal_ch

    script:
        """
        trimal -in ${id}*nt_*.fasta -out ${id}_masked.fasta -gt ${masking_threshold}
        """
}
