process PASTA{
    label 'pasta'
    label 'big_mem'
    
    publishDir(path: "${publish_dir}/pasta", mode: "symlink")

    input:
        tuple val(id), path(seqkit)
        
    output:
        path("${id}_pasta.aa"), emit: pasta_ch

    script:
        """
         python run_pasta.py \
        -i ${id}.aa \
        -j ${id}.aa \
        -o ${id}_pasta.aa \
        -d Protein \
        --max-mem-mb 2048; done
        cd ..
        """
}
