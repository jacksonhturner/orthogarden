process CUTADAPT_ADAPTERS {
    label "cutadapt"
    label "lil_mem"

    publishDir(path: "${publish_dir}/cutadapt", mode: "symlink")

    input:
        tuple val(id), path(r1), path(r2), val(augustus)
        val r1_adapter
        val r2_adapter
        val minimum_length

    output:
        tuple val(id), path("cut_${r1}"), path("cut_${r2}"), val(augustus), emit : reads

    script:
        forward = "cut_${r1}"
        reverse = "cut_${r2}"
        """
        cutadapt \
          -a ${r1_adapter} \
          -A ${r2_adapter} \
          -m ${minimum_length} \
          -o $forward \
          -p $reverse \
          $r1 $r2 
        """
}
