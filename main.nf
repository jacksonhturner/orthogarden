nextflow.enable.dsl=2

include { PARSE_METADATA                    } from "./modules/metadata.nf"
include { CUTADAPT_ADAPTERS                 } from "./modules/cutadapt.nf"
include { FASTQC as FASTQC_RAW              } from "./modules/fastqc.nf"
include { FASTQC as FASTQC_TRIM             } from "./modules/fastqc.nf"
include { MULTIQC as MULTIQC_RAW            } from "./modules/multiqc.nf"
include { MULTIQC as MULTIQC_TRIM           } from "./modules/multiqc.nf"
include { KRAKEN2                           } from "./modules/kraken2.nf"
include { MEGAHIT                           } from "./modules/megahit.nf"
include { AUGUSTUS as AUGUSTUS_FASTA        } from "./modules/augustus.nf"
include { AUGUSTUS as AUGUSTUS_READS        } from "./modules/augustus.nf"
include { AUGUSTUS_PROT                     } from "./modules/augustus.nf"
include { ORTHOFINDER ; ORTHOFINDER_FINDER  } from "./modules/orthofinder.nf"
include { SUMMARY_TABLE                     } from "./modules/summary_table.nf"
include { MAFFT                             } from "./modules/mafft.nf"
include { ALIGN_NT                          } from "./modules/seq_utils.nf"
include { TRIMAL                            } from "./modules/trimal.nf"
include { MSTATX                            } from "./modules/mstatx.nf"
include { MSTATX_SCORES                     } from "./modules/mstatx_scores.nf"
include { IQTREE ; IQTREE_WITH_THIRDS       } from "./modules/iqtree.nf"
include { FIX_FRAMES ; REMOVE_THIRDS        } from "./modules/seq_utils.nf"

workflow {

    /*
    ---------------------------
    PREPARE INPUT FROM METADATA
    ---------------------------
    */

    ch_input = file(params.input)

    PARSE_METADATA(ch_input)

    PARSE_METADATA.out.reads_csv
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( row.id, file(row.r1), file(row.r2), row.augustus ) }
    .set { ch_reads_raw }

    PARSE_METADATA.out.fasta_csv
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( row.id, file(row.ref), row.augustus ) }
    .set { ch_fasta }

    /*
    -------------------------
    PERFORM RAW DATA TRIMMING
    -------------------------
    */

    if (!params.skip_qc) {
        FASTQC_RAW(ch_reads_raw, "raw")
        MULTIQC_RAW(FASTQC_RAW.out.fastq_ch.collect(), "raw")
    }

    if (!params.skip_trim) {
        CUTADAPT_ADAPTERS(ch_reads_raw, params.r1_adapter, params.r2_adapter, params.minimum_length)
        ch_reads_pre_kraken = CUTADAPT_ADAPTERS.out.reads

        if (!params.skip_qc) {
            FASTQC_TRIM(ch_reads_pre_kraken, "trimmed")
            MULTIQC_TRIM(FASTQC_TRIM.out.fastq_ch.collect(), "trimmed")
        }

     } else {
         ch_reads_pre_kraken = ch_reads_raw
     }

    /*
    -----------------------
    CONTAMINATION FILTERING
    -----------------------
    */

    if (params.kraken_db) {
        KRAKEN2(ch_reads_pre_kraken, params.kraken_db)
        ch_reads_pre_assembly = KRAKEN2.out.reads
    } else {
        ch_reads_pre_assembly = ch_reads_pre_kraken
    }

    /*
    --------------
    ASSEMBLE READS
    --------------
    */

    MEGAHIT(ch_reads_pre_assembly)

    /*
    ---------------
    GENE PREDICTION
    ---------------
    */

    AUGUSTUS_FASTA(ch_fasta)
    AUGUSTUS_READS(MEGAHIT.out.megahit_ch)
    AUGUSTUS_PROT(AUGUSTUS_FASTA.out.augustus_ch.concat(AUGUSTUS_READS.out.augustus_ch))

    /*
    -------------------
    ORTHOLOGY INFERENCE 
    -------------------
    */

    ORTHOFINDER(AUGUSTUS_PROT.out.aa_ch.collect(),
                params.ulimit)
    ORTHOFINDER_FINDER(ORTHOFINDER.out.orthofinder_ch,
                       params.threshold_val,
                       params.limit_ogs,
                       AUGUSTUS_PROT.out.codingseq_ch.collect(),
                       AUGUSTUS_PROT.out.aa_ch.collect())
    FIX_FRAMES(ORTHOFINDER_FINDER.out.protein_ch.collect(),
               ORTHOFINDER_FINDER.out.codingseq_ch.collect())

    /*
    -------------------------
    OG SUMMARY TABLE CREATION
    -------------------------
    */

    SUMMARY_TABLE(ORTHOFINDER_FINDER.out.protein_ch)

    /*
    --------------------------
    PROTEIN SEQUENCE ALIGNMENT 
    --------------------------
    */

    MAFFT(ORTHOFINDER_FINDER.out.protein_ch.flatten().buffer(size: params.buffer_n, remainder: true))

    FIX_FRAMES.out.fixed_ch.flatten().map{[it.toString().split("\\.fa")[0].split("/")[-1], it]}.set{codingseq_ch}
    MAFFT.out.mafft_ch.flatten().map{[it.toString().split("\\.faa")[0].split("/")[-1], it]}.set{protein_ch}
    codingseq_ch
        .combine(protein_ch, by: 0)
        .map{id, prot, codingseq -> [prot, codingseq]}.set{combined_ch}

    ALIGN_NT(combined_ch.flatten().buffer(size: params.buffer_n*2, remainder: true))
    TRIMAL(ALIGN_NT.out.align_nt_ch.flatten().buffer(size: params.buffer_n, remainder: true), params.masking_threshold)

    /*
    ----------------
    ALIGNMENT SCORES
    ----------------
    */

    MSTATX(TRIMAL.out.trimal_ch.flatten().buffer(size: params.buffer_n, remainder: true))
    MSTATX_SCORES(MSTATX.out.mstatx_ch.collect())

    /*
    --------------------------
    PHYLOGENETIC TREE CREATION 
    --------------------------
    */

    if (!params.retain_third_pos) {
            REMOVE_THIRDS(TRIMAL.out.trimal_ch.flatten().buffer(size: params.buffer_n, remainder: true))
            IQTREE(REMOVE_THIRDS.out.remove_thirds_ch.collect())
        } else {
            IQTREE_WITH_THIRDS(TRIMAL.out.trimal_ch.collect())
    }

}
