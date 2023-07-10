process TRIMMOMATIC {
    label 'trimmomatic'

    publishDir(path: "${publish_dir}/trimmomatic/, mode: "symlink")

    input: 
        tuple val(id), path(r1), path(r2)
        path(reads)
        val adapters
        val leading
        val trailing
        val slidingwindow 
        val minlen

    output:
        tuple val($id, path("trimmomatic_${reads.r1}_paired.fastq.gz"), path("trimmomatic_${reads.r2}_paired.fastq.gz"), emit: trimmed_reads

    script:
        """
        java -jar trimmomatic-0.39.jar PE \
        ${r1} \
        ${r2} \
        ${r1}_paired.fastq.gz \
        ${r1}_unpaired.fastq.gz \
        ${r2}_paired.fastq.gz \
        ${r2}_unpaired.fastq.gz \
        ILLUMINACLIP:${adapters} LEADING:${leading} TRAILING:${trailing} SLIDINGWINDOW:${slidingwindow} MINLEN:${minlen}
        """
}
