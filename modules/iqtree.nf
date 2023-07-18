process IQTREE {
   label 'iqtree'
   label 'sup_mem'

   publishDir(path: "${publish_dir}/iqtree", mode: "symlink")   

   input:
      path(alignments_for_tree)

   output:
      path("${alignments_for_tree}.*"), emit: iqtree_ch

   script:
       """
       iqtree2 -p ${alignments_for_tree} -m MFP+MERGE -B 1000 -rcluster 10 -bnni -nt ${task.cpus}
       """

}
