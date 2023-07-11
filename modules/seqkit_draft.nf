process SEQKIT {
    label 'seqkit'
    label 'lil_mem"

    publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

    input:
        tuple val (ortho_id), path(ortholog_nucl)

    output:
        path("${id}.aa"), emit: seqkit_ch
        
    script:
        """
        seqkit translate ${id}.fasta > ${id}.aa; done
        """
}
