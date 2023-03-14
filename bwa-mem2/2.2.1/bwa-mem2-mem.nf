process bwa_mem2_mem {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}-pre.flagstat"
    label "bwa"

    conda "$projectDir/conf/bwa2.yaml"

    input:
        tuple val(id), 
              file(reads),
              file(asm),
              file(fai),
              file(idx)
        val platform
        val mapq
        val outdir
    
    output:
        path "${id}-pre.flagstat", emit: multiqc
        tuple val(id), path("${id}.raw.bam"), emit: bam
        
    script:
        """
        # Align reads
        bwa-mem2 mem \
		    -t ${task.cpus} \
            -R \"@RG\\tID:${id}\\tSM:${id}\\tPL:${platform}\\tLB:LIB.${id}\" \
		    ${asm} \
		    ${reads} |
        samtools sort -u |
        samtools view --bam -o ${id}.tmp.bam

        # Export flagstat before any filtering
        samtools flagstat -@ ${task.cpus} ${id}.tmp.bam > ${id}-pre.flagstat

        samtools view \
            --bam \
            --require-flags 3 \
            --exclude-flags 4 \
            --min-MQ ${mapq} \
            -o ${id}.raw.bam \
            ${id}.tmp.bam

        rm ${id}.tmp.bam
        """
    stub:
        """
        touch "${id}-pre.flagstat" "${id}.raw.bam"
        """
}
