process SEQKIT {
  label "seqkit"
  label "lil_mem"

  publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

  input:
    path(ortho_id)

  output:
    tuple path(ortho_id), path("*.aa"), emit: seqkit_ch
        
  script:
    """
    seqkit translate ${ortho_id} > ${ortho_id.baseName}.aa
    """
}
