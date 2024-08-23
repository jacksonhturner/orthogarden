process MSTATX_SCORES {
    label "mstatx_scores"
    label "pandas"
    label "lil_mem"

    publishDir(path: "${publish_dir}/mstatx_scores/", mode: "copy")

    input:
        path(mstatx)
        
    output:
        path("mstatx_scores.csv"), emit: mstatx_scores_ch 
        
    script:
        """
        mkdir msa_scores_gen
        cp *.* msa_scores_gen

        msa_scores_per_gene.py msa_scores_gen mstatx_scores.csv
        """
}
