#!/bin/bash

nextflow run ../../../main.nf \
    --input metadata.csv \
    --threshold_val 0.9 \
    --publish_dir results \
    --ulimit 20000 \
    -profile local,two \
    -resume
