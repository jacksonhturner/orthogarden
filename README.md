# Orthogarden :seedling:

logo

a super brief description of what it does. (~2 sentences)  
inputs  
outputs  

## contents
- [overview](#overview)
- [usage](#usage)
  - [requirements](#requirements)
  - [quick start](#quick-start)
- [accessing and interpreting output](#accessing-and-interpreting-output)
- [license](#license)

## overview

Orthogarden is a nextflow pipeline designed to leverage any combination of short reads and assemblies to generate a robust and accurate ML phylogeny with minimal user input. It attempts to accomplish this by first trimming reads, filtering reads for non-target contamination, de novo assembling reads, annotating assemblies, extracting orthologs from assemblies, and using harvested orthologs to create a phylogeny. A Nextflow-based architecture allows Orthogarden to run seamlessly from initiation to completion with little required knowledge of command line beyond installing dependencies and editing a config file to user standards. Extracting orthologs directly from de novo assemblies for direct comparison between taxa sets Orthogarden apart from other phylogenomics pipelines as it does not require a pre-selected suite of reference orthologs to function. Orthogarden is highly scalable and is demonstrated to generate accurate phylogenies from large and small datasets of varying sample quality.

Overview of pipeline:

```mermaid
flowchart TB
    subgraph " "
    subgraph params
    v9["r1_adapter"]
    v32["buffer_n"]
    v28["limit_ogs"]
    v25["ulimit"]
    v42["retain_third_pos"]
    v5["skip_qc"]
    v27["threshold_val"]
    v11["minimum_length"]
    v0["input"]
    v38["masking_threshold"]
    v17["kraken_db"]
    v8["skip_trim"]
    v10["r2_adapter"]
    end
    v2([PARSE_METADATA])
    v6([FASTQC_RAW])
    v7([MULTIQC_RAW])
    v12([CUTADAPT_ADAPTERS])
    v14([FASTQC_TRIM])
    v15([MULTIQC_TRIM])
    v18([KRAKEN2])
    v21([MEGAHIT])
    v22([AUGUSTUS_FASTA])
    v23([AUGUSTUS_READS])
    v24([AUGUSTUS_PROT])
    v26([ORTHOFINDER])
    v29([ORTHOFINDER_FINDER])
    v30([FIX_FRAMES])
    v31([SUMMARY_TABLE])
    v33([MAFFT])
    v37([TRANSLATORX])
    v39([TRIMAL])
    v40([MSTATX])
    v41([MSTATX_SCORES])
    v43([REMOVE_THIRDS])
    v44([IQTREE])
    v45([IQTREE_WITH_THIRDS])
    v0 --> v2
    v2 --> v6
    v6 --> v7
    v2 --> v12
    v9 --> v12
    v10 --> v12
    v11 --> v12
    v12 --> v14
    v14 --> v15
    v17 --> v18
    v2 --> v18
    v2 --> v21
    v2 --> v22
    v21 --> v23
    v22 --> v24
    v23 --> v24
    v24 --> v26
    v25 --> v26
    v24 --> v29
    v26 --> v29
    v27 --> v29
    v28 --> v29
    v29 --> v30
    v29 --> v31
    v32 --> v33
    v29 --> v33
    v32 --> v37
    v33 --> v37
    v30 --> v37
    v32 --> v39
    v37 --> v39
    v38 --> v39
    v32 --> v40
    v39 --> v40
    v40 --> v41
    v32 --> v43
    v39 --> v43
    v43 --> v44
    v39 --> v45
    end
```

## usage

For full documentation on using orthogarden, please see the [Orthogarden Wiki](https://github.com/jacksonhturner/orthogarden/wiki).

## requirements

## quick start

Include test dataset and a quick run of the pipeine

#TODO links to relevant wikis

## accessing and interpreting output

## license

<a href="https://github.com/jacksonhturner/orthogarden/blob/master/LICENSE">MIT license</a>
