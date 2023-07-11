process POST_ORTHOFINDER {

// i'm not sure this step needs to exist but here it is anyway, for now! //

    input:
        path(orthofinder_results)

    output:
        path("orthofinder_results"), emit: post_orthofinder.ch

    script:
        """
        cd ${orthofinder_finder_results}
        mkdir 1_nucl_seqs
        mkdir 2_aa_seqs
        mkdir 3_pasta
        mkdir 4_translatorx
        mkdir 5_trimal_input
        mkdir 6_trimal_output
        mkdir 7_no_3rds
        mv *.fasta 1_nucl_seqs
        """
}

process SEQKIT {
    label 'seqkit'

    publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

    input:
        path(post_orthofinder)

    output:
        path("2_nucl_seqs"), emit: seqkit_ch
        
    script:
        """
        cd 1_nucl_seqs
        for FILE in *.fasta; do seqkit translate $FILE > ../2_aa_seqs; done
        cd ..
        """
}
