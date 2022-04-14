process matlock_bam2 {
    tag { "matlock_bam2 ${bam.simpleName}" }
    publishDir enabled: false
    label "bam2mnd"

    conda "$projectDir/conf/3ddna.yaml"

    input:
        file bam
        val outdir
    
    output:
        path "sorted.links.txt"
        
    script:
        """
        matlock bam2 juicer ${bam} links.txt || exit 1
        sort -T \$PWD --parallel=${task.cpus} -k2,2 -k6,6 links.txt > sorted.links.txt || exit 1
        rm -v links.txt
        """
}
