nextflow run ../main.nf \
--input metadata.csv \
--publish_dir test_run2/ \
--kraken_db /pickett_shared/databases/k2_pluspf_20230314/ \
--augustus_ref "aedes" \
--threshold_val 0.5
-profile local,eight \
-process.echo
-resume
