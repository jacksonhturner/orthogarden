# orthogarden

## installation and requirements

## usage

To use orthogarden, you'll need to provide a comma-separated (csv) metadata file that contains *either* paired-end sequences or assembled reference genomes.

The formatting must match the following, including header:
```
id,r1,r2,ref
taxonA,/path/to/forward.fastq,/path/to/reverse.fastq,
taxonB,/path/to/forward.fastq/path/to/reverse.fastq,
taxonC,,,reference.fna
```


## todo:
- [x] create main.nf
- [x] create nextflow.config
- [x] start a few modules
- [ ] add support for single-end reads
- [ ] create configs (dir) with local and slurm
- [x] determine the best container for each tool
  - prioritize quay.io most of the time
  - biocontainers as well
  - dockerhub is also good
- [ ] determine 4 or so smaller files to test the pipeline
  - also consider files that performed poorly with/without trimming
  - also consider running Marcin's files again to confirm output
  - also consider running Axel's beetles
- [ ] implement recovery step after assembly


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


## stretch goal:
- allow a pre-made augustus training model (fire, directory)
- create better orthologs from poor assemblies using nearest neighbors from final phylogeny
