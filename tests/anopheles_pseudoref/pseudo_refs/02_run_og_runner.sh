#!/bin/bash

nextflow run ../../../main.nf \
    --input metadata_runner.csv \
    --threshold_val 0.9 \
    --publish_dir results \
    --ulimit 20000 \
    -profile gh_test,two \
    -resume
