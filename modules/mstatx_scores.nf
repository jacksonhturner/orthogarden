process MSTATX_scores {
    label "mstatx_scores"
    label "lil_mem"

    publishDir(path: "${publish_dir}/mstatx_scores/", mode: "copy")

    input:
        path(mstatx_dir)
        
    output:
        path("OrthoFinder/Results*"), emit: mstatx_scores_ch 
        
    script:
        """
        mstatx.py ${path} mstatx_scores.csv
        """
}
