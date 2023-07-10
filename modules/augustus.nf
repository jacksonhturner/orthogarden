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
