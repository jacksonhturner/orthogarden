process FASTP_ADAPTERS {
    label "fastp"
    label "lil_mem"

    publishDir { "${params.publish_dir}/publish/fastp" }, mode: "symlink"

    input:
        tuple val(id), path(r1), path(r2), val(augustus)
        val minimum_length

    output:
        tuple val(id), path("cut_${r1}"), path("cut_${r2}"), val(augustus), emit : reads

    script:
        forward = "cut_${r1}"
        reverse = "cut_${r2}"
        """
        fastp \
          --thread $task.cpus \
          -i $r1 \
          -I $r2 \
          -o $forward \
          -O $reverse \
          --trim_poly_g \
          --length_required ${minimum_length}
        """
}

