process MEGAHIT {
    label 'megahit'
    label 'big_mem'

    publishDir(path: "${publish_dir}/megahit/", mode: "copy")

    input:
        tuple val(id), path(r1), path(r2)

    output:
        tuple val(id), path("*final.contigs.fa"), emit: megahit_ch

    script:
        """
        megahit -1 ${r1} -2 ${r2} -t ${task.cpus} -o megahit_result
        mv megahit_result/final.contigs.fa ${id}_final.contigs.fa
        """
}
