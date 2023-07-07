process CUTADAPT_ADAPTERS {
    label 'cutadapt'
    label 'lil_mem'

    publishDir(path: "${publish_dir}/cutadapt", mode: "symlink")

    input:
        tuple val(metadata), path(reads)
        val r1_adapter
        val r2_adapter
        val minimum_length

    output:
        tuple val(metadata), path("cut*") , emit : reads

    script:
        if (metadata.readType == 'single') {
            forward = "cut_${reads[0]}"
            """
            cutadapt \
              -a ${r1_adapter} \
              -m ${minimum_length} \
              -o $forward \
              $reads 
            """
        } else {
            forward = "cut_${reads[0]}"
            reverse = "cut_${reads[1]}"
            """
            cutadapt \
              -a ${r1_adapter} \
              -A ${r2_adapter} \
              -m ${minimum_length} \
              -o $forward \
              -p $reverse \
              $reads 
            """
        }
}
