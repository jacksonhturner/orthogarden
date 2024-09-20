process ORTHOFINDER {
    label "orthofinder"
    label "big_time"

    publishDir(path: "${publish_dir}/orthofinder/", mode: "symlink")

    input:
        path('*')
        val ulimit
        
    output:
        path("OrthoFinder/Results*"), emit: orthofinder_ch 
        
    script:
        """
        ulimit -n $ulimit
        orthofinder \
          -t ${task.cpus} \
          -f . \
          -og
        """
}

process ORTHOFINDER_FINDER {
    label "pandas"
    label "lil_mem"

    publishDir(path: "${publish_dir}/orthofinder_finder/", mode: "copy")

    input:
        path(orthofinder_dir)
        val(threshold_val)
        val(limit_ogs)
        path(codingseq_ch)
        path(aa_ch)

    output:
        path("off_narrowed_${threshold_val}/*.faa"), emit: protein_ch
        path("off_narrowed_${threshold_val}/*.fna"), emit: codingseq_ch
        path("off_narrowed_${threshold_val}/*.csv"), emit: csv_ch

    script:
        """
        mkdir off_narrowed_${threshold_val}
        mkdir sequences
        mv *.codingseq sequences
        mv *.faa sequences

        orthofinder_finder.py \
          ${orthofinder_dir} \
          ${threshold_val} \
          sequences \
          off_narrowed_${threshold_val} \
          $limit_ogs
        """
}
