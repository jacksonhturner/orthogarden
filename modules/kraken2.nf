/* still quite drafty :') */

process KRAKEN2 {
  label 'kraken2'
  label 'sup_mem'

  publishDir(path: "${publish_dir}/kraken/", mode: "symlink")

  input:  
    tuple val(id), path(r1), path(r2)
    path(kraken_db)
  
  output:
    tuple val(id), path("*1.unclassified.fq"), path("*2.unclassified.fq"), emit : reads
  
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
