/* still quite drafty :') */

process KRAKEN2 {
  label 'kraken2'

  publishDir(path: "${publishDir}/kraken/${outdir_name}", mode:copy)

  input:  
    tuple val path(id), path(r1), path (r2)
    path(trimmed_reads)
    path(kraken_database) // do we want to give users the ability to choose their own database? //
  
  output:
    path(${metadata.sample_id}.1.unclassified.fq), path(${metadata.sample_id}.2.unclassified.fq), emit: kraken_ch
  
  script:
    """
    kraken2 
    --db ${kraken_database} 
    --paired 
    --report ${metadata.sample_id}.kreport 
    --unclassified-out ${metadata.sample_id}.#.unclassified.fq ${trimmed_reads}.r1 ${trimmed_reads}.r2 > ${metadata.sample_id}_kraken
    --threads 5
    """
}
