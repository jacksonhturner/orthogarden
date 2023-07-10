process ORTHOFINDER {
    label 'orthofinder'

    publishDir(path: "${publish_dir}/orthofinder/", mode: "symlink")

    input:
        path(all_aa) // can nextflow have a queue channel with a directory? i'll need to do some more research //
        
    output:
        // orthofinder results directory //, emit: orthofinder_ch
        
    script:
        """
        ulimit -n 10000
        orthofinder \
        -t 10 \
        -f ${aa_seqs}
        """
}
