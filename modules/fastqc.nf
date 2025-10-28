process FASTQC {
    label 'fastqc'
    label 'big_mem'

    publishDir(path: "${params.publish_dir}/publish/qc/${outdir_name}", mode: "copy")

    input:
        tuple val(id), path(r1), path(r2), val(augustus)
        val outdir_name

    output:
        path("fastqc_${id}_logs"), emit: fastq_ch

    script:
        """
        mkdir fastqc_${id}_logs
        fastqc -o fastqc_${id}_logs -q ${r1} ${r2}
        """
}
