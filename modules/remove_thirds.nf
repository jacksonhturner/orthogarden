process REMOVE_THIRDS {
    label 'pandas'
    label 'sup_mem'

    publishDir(path: "${publish_dir}/remove_thirds", mode: "symlink")

    input: 
       path(trimal)

    output:
       path("${trimal}.no3rds"), emit: remove_thirds_ch

    script:
       """
       pull_third_pos.py ${trimal} ${trimal}.no3rds
       """
}
