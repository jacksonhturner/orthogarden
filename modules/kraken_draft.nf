process KRAKEN2 {
  label 'kraken2'

  publishDir(path: "${publishDir}/kraken/${outdir_name}", mode:copy)

  input:  
    tuple val(id), path(trimmed_reads.r1), path (trimmed_reads.r2)
    path(kraken_database) // do we want to give users the ability to choose their own database? //
  
  output:
    tuple val(id), path("${metadata.sample_id}.1.unclassified.fq"), path("${metadata.sample_id}.2.unclassified.fq"), emit: kraken_ch
  
  script:
    """
    kraken2 \
    --db ${kraken_database} \
    --paired \
    --report ${metadata.sample_id}.kreport \
    --unclassified-out ${metadata.sample_id}.#.unclassified.fq ${trimmed_reads}.r1 ${trimmed_reads}.r2 > ${metadata.sample_id}_kraken \
    --threads 5
    """
}
