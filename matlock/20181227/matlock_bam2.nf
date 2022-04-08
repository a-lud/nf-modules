process matlock_bam2 {
    tag { "matlock_bam2 ${id}" }
    publishDir enabled: false
    label "..." // TODO: work out resources

    conda "$projectDir/conf/3ddna.yaml"

    input:
        file bam
        val outdir
    
    output:
        tuple path("${id}.sorted.links.txt")
        
    script:
        """
        matlock bam2 juicer ${bam} ${id}.links.txt
        sort -T \$PWD --parallel=${task.cpus} -k2,2 -k6,6 ${id}.links.txt > ${id}.sorted.links.txt
        """
}
