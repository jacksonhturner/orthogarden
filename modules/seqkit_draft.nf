process SEQKIT {
  label "seqkit"
  label "lil_mem"

  publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

  input:
    path(orthofinder_finder_ch)

  output:
    path("*.aa"), emit: seqkit_ch
        
  script:
    """
    cd off_narrowed*
    for FILE in *.fasta; do seqkit translate $FILE > ${FILE%%fa}.aa; done
    """
}
