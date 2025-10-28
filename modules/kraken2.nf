process KRAKEN2 {
  label "kraken2"
  label "sup_mem"

  publishDir(path: "${params.publish_dir}/publish/kraken/", mode: "symlink")

  input:  
    tuple val(id), path(r1), path(r2), val(augustus)
    path(kraken_db)
  
  output:
    tuple val(id), path("*1.unclassified.fq"), path("*2.unclassified.fq"), val(augustus), emit : reads
  
  script:
    """
    kraken2 \
      --db ${kraken_db} \
      --paired \
      --threads ${task.cpus} \
      --report ${id}.kreport \
      --unclassified-out ${id}.#.unclassified.fq \
      ${r1} ${r2} > ${id}_run.txt
    """
}
