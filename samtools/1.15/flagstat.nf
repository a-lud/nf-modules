process flagstat {
    tag { bam[0].simpleName }
    publishDir "${outdir}", mode: 'copy'
    label "flagstat"

    conda "$projectDir/conf/samtools.yaml"

    input:
        file bam
        val outdir
    
    output:
        path "${bam[0].simpleName}-post.flagstat", emit: multiqc

    script:
        """
        samtools flagstat \
            -@ ${task.cpus} \
            ${bam[0]} > ${bam[0].simpleName}-post.flagstat
         """
}