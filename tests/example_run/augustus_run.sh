nextflow run main.nf \
    --input ../test_orthogarden/metadata.csv \
    --publish_dir ../test_orthogarden/test_run1/ \
    --kraken_db /pickett_shared/databases/k2_pluspf_20230314/ \
    -profile local,eight \
    -process.echo \
    -resume
