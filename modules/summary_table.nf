process SUMMARY_TABLE{
    label 'summary_table'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/summary_table", mode: "symlink")

    input:
      path(orthofinder_finder)

    output:
        path("*.masked"), emit: trimal_ch

    script:
        """
        python3 completeness_table_OG.py . summary_table_with_genes.csv
        python3 summary_table_OG/py summary_table_with_genes.csv summary_table_with_taxon.csv
        """
}
