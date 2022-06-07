process multiqc {
    tag { 'Report' }
    publishDir "${outdir}/${outprefix}/multiqc", mode: 'move'

    conda "$projectDir/conf/multiqc.yaml"

    input:
        file fqc
        file kr2
        file fp
        val outprefix
        val outdir
    
    output:
        path "multiqc_report.html"

    script:
        """
        multiqc --config ${projectDir}/conf/multiqc-config.yaml .
        """
    
    stub:
        """
        touch multiqc_report.html
        """
}