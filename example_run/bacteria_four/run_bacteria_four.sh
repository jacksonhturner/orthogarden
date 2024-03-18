nextflow run ../../../orthogarden/main.nf \
  --input metadata.csv \
  --publish_dir test_run/ \
  --kraken_db /pickett_shared/databases/k2_pluspf_20230314/ \
  --augustus_ref "E_coli_K12" \
  --threshold_val 0.5 \
  --masking_threshold 0.4 \
  --retain_third_pos \
  -profile local,four \
  #-resume
