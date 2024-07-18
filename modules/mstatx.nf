process MSTATX{
    label 'mstatx'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/mstatx", mode: "copy")

    input:
      path(trimal)

    output:
        path("*.mstatx"), emit: mstatx_ch

    script:
        """
        for seq in *; do
            mstatx -i ${file} -s trident -m BLOSUM62_sub_matrix.txt -o ${file}.mstatx;
            sed 's/.*\t//g' ${file}.mstatx > tmp && mv mp ${file}.mstatx;
        done
        """
}
