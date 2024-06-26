#!/bin/bash

nextflow run ~/nextflow/orthogarden/main.nf \
    --input metadata.csv \
    --threshold_val 0.9 \
    --publish_dir results \
    -profile local,eight \
    -resume
