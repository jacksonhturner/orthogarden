process AUGUSTUS {
    label "augustus"
    // label "med_mem"

    // publishDir(path: "${publish_dir}/augustus", mode: "symlink")

    input:
        tuple val(id), path(fasta)
        val augustus_ref

    output:
        tuple val(id), path("*.gff"), emit: augustus_ch

    script:
        """
        augustus --codingseq=on --species=${augustus_ref} ${fasta} > ${id}.gff
        """
}

process AUGUSTUS_PROT {
    label "augustus"

    input:
        tuple val(id), path(gff)

    output:
        path("*.aa"), emit: aa_ch
        path("*.codingseq"), emit: codingseq_ch

    script:
        """
        getAnnoFasta.pl $gff
        """
}
