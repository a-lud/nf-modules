process flagstat {
    tag { bam[0].simpleName }
    publishDir "${outdir}/post-assembly-qc/alignment-statistics", mode: 'move'
    label "flagstat"

    conda "$projectDir/conf/samtools.yaml"

    input:
        file bam
        val outdir
    
    output:
        path "${bam[0].simpleName}.tsv"

    script:
        """
        samtools flagstat \
            -@ ${task.cpus} \
            -O tsv \
            ${bam[0]} > ${bam[0].simpleName}.tsv
         """
}