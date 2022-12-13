process samtools_consensus {
    tag { id }
    publishDir enabled: false
    label "consensus"
    conda "$projectDir/conf/samtools-1.16.1.yaml"

    input:
        tuple val(id), path(bam), path(bai), path(regions)
        val minMQ
        
    output:
        tuple val(id), path("${id}-consensus.fq.gz")
        
    script:
        def reg = regions.getName() != "EMPTY" ? "--targets-file ${regions}" : ''
        """
        samtools view -h ${reg} ${bam} | \
        samtools consensus -@ ${task.cpus} --format fastq --min-MQ ${minMQ} --ambig - | \
        bgzip > ${id}-consensus.fq.gz
        """
    
    stub:
        def reg = regions.getName() != "EMPTY" ? "--regions-file ${regions}" : ''
        """
        echo "samtools view -h ${reg} ${bam} |
        samtools consensus -@ ${task.cpus}--format fastq --min-MQ ${minMQ} --ambig |
        bgzip > ${id}-consensus.fq.gz"
        touch ${id}-consensus.fq.gz
        """
} 
 
