/* still quite drafty :') */

process KRAKEN2 {
  label 'kraken2'

  publishDir(path: "${publishDir}/kraken/${outdir_name}", mode:copy)

  input:  
    tuple val(metadata), path(trimmed_reads)
    path(kraken_database) // do we want to give users the ability to choose their own database? //
    val outdir_name
  
  output:
    path("kraken_${metadata.sampleName}), emit: kraken_ch
  
  script:
    """
    kraken2 
    --db ${kraken_database} 
    --paired 
    --report $sample_id.kreport 
    --unclassified-out ${sample_id}.#.unclassified.fq ${trimmed_reads}.r1 ${trimmed_reads}.r2 > ${outdir_name}_kraken
    --threads 5
    """
}
