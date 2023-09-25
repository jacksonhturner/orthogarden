process MASURCA_CONFIG {
    label "pandas"
    label "sup_mem"

    input:
        tuple val(id), path(r1), path(r2)

    output:
        tuple val(id), path(r1), path(r2), path("${id}_config.txt"), emit: masurca_config

    script:
        """
        masurca_config.py "${r1}" "${r2}" "${id}" ${task.cpus}
        """
}

process MASURCA_ASSEMBLE {
    label "masurca"
    label "sup_mem"

    publishDir(path: "${publish_dir}/masurca", mode: "symlink")

    input:
        tuple val(id), path(r1), path(r2), path(config)

    output:
        tuple val(id), path("CA/primary.genome.scf.fasta"), emit: masurca_ch

    script:
        """
        masurca ${config}
        ./assemble.sh
        """
}
