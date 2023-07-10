process TRIMMOMATIC {
    // draft //
  
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
        tuple val($metadata.sample_id), path("trimmomatic_${reads.r1}_paired.fastq.gz"), path("trimmomatic_${reads.r2}_paired.fastq.gz"), emit: trimmed_reads

    script:
        """
        java -jar trimmomatic-0.39.jar PE \
        ${reads.r1} \
        ${reads.r2} \
        ${reads.r1}_paired.fastq.gz \
        ${reads.r1}_unpaired.fastq.gz \
        ${reads.r2}_paired.fastq.gz \
        ${reads.r2}_unpaired.fastq.gz \
        ILLUMINACLIP:${adapters} LEADING:${leading} TRAILING:${trailing} SLIDINGWINDOW:${slidingwindow} MINLEN:${minlen}
        """
}
