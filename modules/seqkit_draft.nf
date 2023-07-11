process SEQKIT {
    label 'seqkit'
    label 'lil_mem"

    publishDir(path: "${publish_dir}/seqkit", mode: "symlink")

    input:
        tuple val (ortho_id), path(ortholog_nucl)

    output:
        path("2_nucl_seqs"), emit: seqkit_ch
        
    script:
        """
        seqkit translate ${id}_nucl.fasta > {id}_aa.fasta; done
        """
}
