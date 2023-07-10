nextflow.enable.dsl=2

include { PARSE_METADATA                  } from "./modules/metadata.nf"
include { CUTADAPT_ADAPTERS               } from "./modules/cutadapt.nf"
include { FASTQC as FQRAW                 } from "./modules/fastqc.nf"
include { FASTQC as FQTRIM                } from "./modules/fastqc.nf"
include { MULTIQC as MQRAW                } from "./modules/multiqc.nf"
include { MULTIQC as MQTRIM               } from "./modules/multiqc.nf"
include { KRAKEN2                         } from "./modules/kraken2.nf"

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
        FQRAW(ch_reads_raw, "raw")
        MQRAW(FQRAW.out.fastq_ch.collect(), "raw")
    }

    if (!params.skip_trim) {
        CUTADAPT_ADAPTERS(ch_reads_raw, params.r1_adapter, params.r2_adapter, params.minimum_length)
        ch_reads_pre_kraken = CUTADAPT_ADAPTERS.out.reads

        if (!params.skip_trim_qc) {
            FQTRIM(ch_reads_pre_kraken, "trimmed")
            MQTRIM(FQTRIM.out.fastq_ch.collect(), "trimmed")
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
}


