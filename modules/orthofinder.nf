process ORTHOFINDER {
    label "orthofinder"
    label "big_mem"

    publishDir(path: "${publish_dir}/orthofinder/", mode: "symlink")

    input:
        path('*')
        
    output:
        path("OrthoFinder/Results*"), emit: orthofinder_ch 
        
    script:
        """
        ulimit -n 10000
        orthofinder \
          -t ${task.cpus} \
          -f .
        """
}

process ORTHOFINDER_FINDER {
    label "pandas"
    label "med_mem"

    publishDir(path: "${publish_dir}/orthofinder_finder/", mode: "symlink")

    input:
        path(orthofinder_dir)
        val(threshold_val)
        path(codingseq_ch)

    output:
        path("off_narrowed_${threshold_val}/*.fa"), emit: off_ch

    script:
        """
        mkdir off_narrowed_${threshold_val}
        mkdir codingseqs
        mv *.codingseq codingseqs

        orthofinder_finder.py \
          ${orthofinder_dir} \
          ${threshold_val} \
          codingseqs \
          off_narrowed_${threshold_val}
        """
}
