process SUMMARY_TABLE{
    label 'summary_table'
    label 'pandas'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/summary_table", mode: "symlink")

    input:
        path(orthofinder_finder)

    output:
        path("summary_table_with_genes.tsv"), emit: gene_table
        path("summary_table_with_taxon.tsv"), emit: taxon_table

    script:
        """
        completeness_table_OG.py . summary_table_with_genes.tsv
        summary_table_OG.py summary_table_with_genes.tsv summary_table_with_taxon.tsv
        """
}
