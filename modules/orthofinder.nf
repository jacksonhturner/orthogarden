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
        ulimit -n 100000
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
        path(aa_ch)

    output:
        path("off_narrowed_${threshold_val}/*.faa"), emit: protein_ch
        path("off_narrowed_${threshold_val}/*.fna"), emit: codingseq_ch

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
          off_narrowed_${threshold_val}
        """
}
