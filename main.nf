nextflow.enable.dsl=2

include { PARSE_METADATA                    } from "./modules/metadata.nf"
include { CUTADAPT_ADAPTERS                 } from "./modules/cutadapt.nf"
include { FASTQC as FASTQC_RAW              } from "./modules/fastqc.nf"
include { FASTQC as FASTQC_TRIM             } from "./modules/fastqc.nf"
include { MULTIQC as MULTIQC_RAW            } from "./modules/multiqc.nf"
include { MULTIQC as MULTIQC_TRIM           } from "./modules/multiqc.nf"
include { KRAKEN2                           } from "./modules/kraken2.nf"
include { MASURCA_CONFIG ; MASURCA_ASSEMBLE } from "./modules/masurca.nf"
include { VELVET                            } from "./modules/velvet.nf"
include { AUGUSTUS as AUGUSTUS_FASTA        } from "./modules/augustus.nf"
include { AUGUSTUS as AUGUSTUS_READS        } from "./modules/augustus.nf"
include { AUGUSTUS_PROT                     } from "./modules/augustus.nf"
include { ORTHOFINDER ; ORTHOFINDER_FINDER  } from "./modules/orthofinder.nf"
include { SEQKIT                            } from "./modules/seqkit.nf"
include { PRE_MAFFT ; MAFFT                 } from "./modules/mafft.nf"
include { TRANSLATORX                       } from "./modules/translatorx.nf"
include { TRIMAL                            } from "./modules/trimal.nf"
include { REMOVE_THIRDS                     } from "./modules/remove_thirds.nf"
include { IQTREE ; IQTREE_WITH_THIRDS       } from "./modules/iqtree.nf"

workflow {
    ch_input = file(params.input)

    PARSE_METADATA(ch_input)

    PARSE_METADATA.out.reads_csv
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( row.id, file(row.r1), file(row.r2) ) }
    .set { ch_reads_raw }

    PARSE_METADATA.out.fasta_csv
    .splitCsv( header: true, sep: ',' )
    .map { row -> tuple( row.id, file(row.ref) ) }
    .set { ch_fasta }

    if (!params.skip_qc) {
        FASTQC_RAW(ch_reads_raw, "raw")
        MULTIQC_RAW(FASTQC_RAW.out.fastq_ch.collect(), "raw")
    }

    if (!params.skip_trim) {
        CUTADAPT_ADAPTERS(ch_reads_raw, params.r1_adapter, params.r2_adapter, params.minimum_length)
        ch_reads_pre_kraken = CUTADAPT_ADAPTERS.out.reads

        if (!params.skip_trim_qc) {
            FASTQC_TRIM(ch_reads_pre_kraken, "trimmed")
            MULTIQC_TRIM(FASTQC_TRIM.out.fastq_ch.collect(), "trimmed")
        }

    } else {
        ch_reads_pre_kraken = ch_reads_raw
    }

    if (!params.skip_kraken) {
        KRAKEN2(ch_reads_pre_kraken, params.kraken_db)
        ch_reads_pre_assembly = KRAKEN2.out.reads
    } else {
        ch_reads_pre_assembly = ch_reads_pre_kraken
    }

    // MASURCA_CONFIG(ch_reads_pre_assembly)
    // MASURCA_ASSEMBLE(MASURCA_CONFIG.out.masurca_config)

    VELVET(ch_reads_pre_assembly)

    AUGUSTUS_FASTA(ch_fasta, params.augustus_ref)
    AUGUSTUS_READS(VELVET.out.velvet_ch, params.augustus_ref)
    AUGUSTUS_PROT(AUGUSTUS_FASTA.out.augustus_ch.concat(AUGUSTUS_READS.out.augustus_ch))

    ORTHOFINDER(AUGUSTUS_PROT.out.aa_ch.collect())
    ORTHOFINDER_FINDER(ORTHOFINDER.out.orthofinder_ch, params.threshold_val, AUGUSTUS_PROT.out.codingseq_ch.collect())

    SEQKIT(ORTHOFINDER_FINDER.out.off_ch.flatten())

    PRE_MAFFT(SEQKIT.out.seqkit_ch)
    MAFFT(PRE_MAFFT.out.pre_mafft_ch)

    TRANSLATORX(MAFFT.out.mafft_ch)
 
    TRIMAL(TRANSLATORX.out.translatorx_ch.flatten(), params.masking_threshold)

if (!params.retain_third_pos) {
        REMOVE_THIRDS(TRIMAL.out.trimal_ch.flatten())
        IQTREE(REMOVE_THIRDS.out.remove_thirds_ch.collect())
    } else {
        IQTREE_WITH_THIRDS(TRIMAL.out.trimal_ch.collect())
}
}
