process SEQKIT {
  label "seqkit"
  label "lil_mem"

  publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

  input:
    path(off_codingseqs)

  output:
    path(off_codingseqs), emit: sk_coding_ch
    path("*.aa"), emit: sk_prot_ch
        
  script:
    """
    for fasta in *.fa ; do
        seqkit translate \${fasta} > \${fasta%%fa}aa
    done
    """
}
