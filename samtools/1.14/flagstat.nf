process flagstat {
    tag { id }
    publishDir "${outdir}/post-assembly-qc/alignment-statistics", mode: 'move'
    label "flagstat"

    conda "$projectDir/conf/samtools.yaml"

    input:
        file bam
        val outdir
    
    output:
        path "${id}.tsv"

    script:
        """
        samtools flagstat \
            -@ ${task.cpus} \
            -O tsv \
            ${bam[0]} > ${id}.tsv
         """
}