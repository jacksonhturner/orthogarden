process PASTA{
    label 'pasta'
    
    publishDir(path: "${publish_dir}/masurca", mode: "symlink")

    input:
        path(seqkit)
        
    output:
        path("3_pasta"), emit: pasta_ch

    script:
        """
        cd 2_aa_seqs
        for FILE in *.fasta; do python run_pasta.py \
        -i $FILE \
        -j $FILE \
        -o ../3_pasta/$FILE \
        -d Protein \
        --max-mem-mb 2048; done
        cd ..
        """
}
