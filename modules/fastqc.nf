process FASTQC {
    label 'fastqc'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/qc/${outdir_name}", mode: "copy")

    input:
        tuple val(id), path(r1), path(r2)
        val outdir_name

    output:
        path("fastqc_${id}_logs"), emit: fastq_ch

    script:
        """
        mkdir fastqc_${id}_logs
        fastqc -o fastqc_${id}_logs -q ${r1} ${r2}
        """
}
