process AUGUSTUS {
    label "augustus"
    label "med_mem"

    // publishDir(path: "${publish_dir}/augustus/gff", mode: "copy")

    input:
        tuple val(id), path(fasta)
	tuple val(id), val(augustus)

    output:
        tuple val(id), path("*.gff"), emit: augustus_ch

    script:
        """
        augustus --codingseq=on --species=${augustus} ${fasta} > ${id}.gff
        """
}

process AUGUSTUS_PROT {
    label "augustus"
    label "lil_mem"

    publishDir(path: "${publish_dir}/augustus/sequences", mode: "copy")

    input:
        tuple val(id), path(gff)

    output:
        path("*.faa"), emit: aa_ch
        path("*.codingseq"), emit: codingseq_ch

    script:
        """
        getAnnoFasta.pl $gff
        mv ${gff.baseName}.aa ${gff.baseName}.faa
        """
}
