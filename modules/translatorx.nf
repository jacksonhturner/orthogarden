process TRANSLATORX {
    label 'translatorx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/translatorx", mode: "copy")

    input:
        path(combined_ch)

    output:
        path("*.mapped.nt_ali.fasta"), emit: translatorx_ch

    script:
        """
        for prot in ./*faa.mafft ; do
            translatorx.pl -i \${prot%%faa.mafft}fa -a \${prot} -o \${prot%%faa.mafft}mapped
        done
        """
}
