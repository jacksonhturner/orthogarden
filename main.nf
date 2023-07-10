nextflow.enable.dsl=2

include { PARSE_METADATA                    } from "./modules/metadata.nf"
include { CUTADAPT_ADAPTERS                 } from "./modules/cutadapt.nf"
include { FASTQC as FASTQC_RAW              } from "./modules/fastqc.nf"
include { FASTQC as FASTQC_TRIM             } from "./modules/fastqc.nf"
include { MULTIQC as MULTIQC_RAW            } from "./modules/multiqc.nf"
include { MULTIQC as MULTIQC_TRIM           } from "./modules/multiqc.nf"
include { KRAKEN2                           } from "./modules/kraken2.nf"
include { MASURCA_CONFIG ; MASURCA_ASSEMBLE } from "./modules/masurca.nf"
include { AUGUSTUS as AUGUSTUS_FASTA        } from "./modules/augustus.nf"
include { AUGUSTUS as AUGUSTUS_READS        } from "./modules/augustus.nf"

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

    MASURCA_CONFIG(ch_reads_pre_assembly)
    MASURCA_ASSEMBLE(MASURCA_CONFIG.out.masurca_config)

    ch_fasta.view()
    AUGUSTUS_FASTA(ch_fasta, params.augustus_ref)
    AUGUSTUS_READS(MASURCA_ASSEMBLE.out.masurca_ch, params.augustus_ref)

    augustus_fasta_ch = AUGUSTUS_FASTA.out.augustus_ch.collect()
    augustus_reads_ch = AUGUSTUS_READS.out.augustus_ch.collect()
    augustus_fasta_ch.join(augustus_reads_ch).view()

}


