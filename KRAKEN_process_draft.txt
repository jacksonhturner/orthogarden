/* this is probably a very rough draft but one day it won't be! :) */

process KRAKEN

  input:
  path sample_id r1 r2
  
  output:
  r1_kraken_out r2_kraken_out
  
  script:
  /* Paired-end data, unclassified out, generates kraken file and kreport */
  """
  kraken2 --db /pickett_shared/databases/k2_pluspf_20230314/ --paired --report $sample_id.kreport --unclassified-out ${sample_id}.#.unclassified.fq ${r1}_R1_paired.fastq.gz ${r2}_R2_paired.fastq.gz > ${sample_id}.kraken --threads 5
  """
