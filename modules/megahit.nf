process MEGAHIT {
    label 'megahit'
    label 'sup_mem'

    publishDir(path: "${publish_dir}/megahit/", mode: "symlink")

    input:
       tuple val(id), path(r1), path(r2)

    output:
       tuple val(id), path("megahit_result/final.contigs.fa"), emit: megahit_ch

    script:
       """
       megahit -1 ${r1} -2 ${r2} -t 15 -o megahit_result
       """
}
