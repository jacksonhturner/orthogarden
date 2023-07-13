process IQTREE {
   label 'iqtree'
   label 'sup_mem'

   input:
      path(alignments_for_tree)
      val(task_cups)

   output:
      ${alignments_for_tree}.treefile

   script:
       """
       iqtree2 -p ${alignments_for_tree} -m MFP+MERGE -B 1000 -rcluster 10 -bnni -nt ${task_cpus}
       """

}
