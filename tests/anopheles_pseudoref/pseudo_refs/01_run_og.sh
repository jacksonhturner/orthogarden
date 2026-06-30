#!/bin/bash

nextflow -version

# this run assumes SCRATCHDIR is defined
nextflow run ../../../main.nf \
    --input metadata.csv \
    --threshold_val 0.9 \
    --publish_dir results \
    -profile local,two \
    -resume

# comment exit below to run without env SCRATCHDIR
exit 0
env -u SCRATCHDIR nextflow run ../../../main.nf \
    --input metadata.csv \
    --threshold_val 0.9 \
    --publish_dir results \
    -profile local,two \
    -resume
