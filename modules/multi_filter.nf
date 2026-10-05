process MULTI_FILTER {
    label 'lil_mem'

    publishDir { "${params.publish_dir}/publish/multi_filter" }, mode: "copy"

    input:
        tuple val(id), path(fasta), val(augustus)
        val (multi_filter)

    output:
        tuple val(id), path("*_pass.fa"), val(augustus), emit: multi_pass_ch

    script:
        """
        filter_multi_scores.py ${fasta} ${multi_filter} ${id}_pass.fa ${id}_fail.fa
        """
}

