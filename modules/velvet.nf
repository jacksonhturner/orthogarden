process VELVET {
    label 'velvet'
    label 'sup_mem'

    publishDir(path: "${publish_dir}/velvet/", mode: "symlink")

    input:
       tuple val(id), path(r1), path(r2)

    output:
       tuple val(id), path("output_dir/contigs.fa"), emit: velvet_ch

    script:
       """
       mkdir output_dir
       velveth output_dir/ 31 -fastq -shortPaired2 ${r1} ${r2}
       velvetg output_dir/ -cov_cutoff auto -min_contig_lgth 500
       """
}
