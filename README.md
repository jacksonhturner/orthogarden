# orthogarden

## todo:
- [x] create main.nf
- [x] create nextflow.config
- [x] start a few modules
- [ ] create configs (dir) with local and slurm
- [ ] determine the best container for each tool
  - prioritize quay.io most of the time
  - biocontainers as well
  - dockerhub is also good
- [ ] determine 4 or so smaller files to test the pipeline
  - also consider files that performed poorly with/without trimming
  - also consider running Marcin's files again to confirm output


## abstract goals:
- name pipeline (orthogarden)
- include config for slurm 
- assume singularity for all tools
- formatting of metadata (tip-labels)
    assume only fastq?
- allow a way to add specimen?


## parameters:
- metadata file
- augustus training species
- profiles
  - local
  - slurm


## steps:
- parse metadate (split fastq and fasta into two channels)
  - check if files are compressed (consider if this matters for entry point)
- trimming
- kraken2
- masurca
- augustus <<< entry point if no fastq
- augustus convert to codingseqs/aa (getAnnoFasta)
- [ collect all genomes here ]
- orthofinder <<< bottleneck, all samples must collect here
- orthofinder_finder (determine what cutoff to use automatically?)
  - consider a range of values
  - create a decision rule
    - desired number genes?
    - elbow approach?
- translate to protein
- align protein sequences to each other (pasta)
- map coding to amino acids
- mask
- remove thirds
- run iqtree
- change tip labels


## stetch goal:
- allow a pre-made augustus training model (fire, directory)


