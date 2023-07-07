/* still quite drafty :') */

process KRAKEN {
  label 'kraken2'

  publishDir(path: "${publishDir)/kraken/${outdir_name}", mode:copy)

  input:  
    tuple val(metadata), path(reads)
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
    --unclassified-out ${sample_id}.#.unclassified.fq ${r1}_R1_paired.fastq.gz ${r2}_R2_paired.fastq.gz > ${sample_id}.kraken 
    --threads 5
    """
}
