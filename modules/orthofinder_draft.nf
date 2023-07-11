process ORTHOFINDER {
    label 'orthofinder'

    /* something should happen before orthofinder to combine all the aa files into one directory, 
    we could talk about this more tomorrow. */

    publishDir(path: "${publish_dir}/orthofinder/", mode: "symlink")

    input:
        path(all_aa)
        // assuming a queue channel can be a directory, which it would make sense if it could be! //
        
    output:
        path("OrthoFinder*"), emit: orthofinder_ch 
        // this should be acting on the orthofinder results directory, assuming that's what orthofinder calls //
        
    script:
        """
        ulimit -n 10000
        orthofinder \
        -t ${task.cpus} \
        -f ${aa_seqs}
        """
}

process ORTHOFINDER_FINDER {
    label 'orthofinder' // should this have an orthofinder label even though we don't need orthofinder for this step? //

    publishDir(path: "${publish_dir}/orthofinder_finder/", mode: "symlink")

    input:
        path(orthofinder_dir)
        val(threshold_val)

    output:
        path("orthofinder_finder*"), emit: orthofinder_finder_ch

    script:
        """
        orthofinder_finder.py ${orthofinder_dir} ${threshold_val}
        """
}
