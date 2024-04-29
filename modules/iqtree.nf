process IQTREE {
   label 'iqtree'
   label 'sup_mem'

   publishDir(path: "${publish_dir}/iqtree", mode: "copy")

   input:
      path(thirds_removed)

   output:
      path("*"), emit: iqtree_ch

   script:
       """
       mkdir run_iqtree
       mv *.no3rds run_iqtree

       iqtree2 -p run_iqtree \
       -m MFP+MERGE \
       -B 1000 \
       -rcluster 10 \
       -bnni \
       -nt ${task.cpus}
       """

}

process IQTREE_WITH_THIRDS {
   label 'iqtree'
   label 'sup_mem'

   publishDir(path: "${publish_dir}/iqtree", mode: "symlink")

   input:
      path(thirds_removed)

   output:
      path("*"), emit: iqtree_ch

   script:
       """
       mkdir run_iqtree
       mv *.masked run_iqtree

       iqtree2 -p run_iqtree \
       -m MFP+MERGE \
       -B 1000 \
       -rcluster 10 \
       -bnni \
       -nt ${task.cpus}
       """

}
