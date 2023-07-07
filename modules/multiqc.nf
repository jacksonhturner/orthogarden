process MULTIQC {
  label 'multiqc'
  label 'lil_mem'

  publishDir(path: "${publish_dir}/qc/${outdir_name}", mode: "copy")

  input:
      path('*')
      val outdir_name

  output:
      path("*html")

  script:
      """
      multiqc .
      """
}
