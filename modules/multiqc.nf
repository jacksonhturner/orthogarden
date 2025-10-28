process MULTIQC {
  label 'multiqc'
  label 'lil_mem'

  publishDir(path: "${params.publish_dir}/publish/qc/${outdir_name}", mode: "copy")

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
