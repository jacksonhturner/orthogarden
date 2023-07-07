process FASTQC {
    label 'fastqc'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/qc/${outdir_name}", mode: "copy")

    input:
        tuple val(metadata), path(reads)
        val outdir_name

    output:
        path("fastqc_${metadata.sampleName}_logs"), emit: fastq_ch

    script:
        """
        mkdir fastqc_${metadata.sampleName}_logs
        fastqc -o fastqc_${metadata.sampleName}_logs -q ${reads}
        """
}
