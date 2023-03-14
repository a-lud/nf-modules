process multiqc {
    tag { 'Report' }
    publishDir "${outdir}", mode: 'move'

    conda "$projectDir/conf/multiqc-1.14.yaml"

    input:
        file files
        path mqc_config
        val intro
        val outdir
    
    output:
        path "multiqc_report.html"

    script:
        """
        multiqc --config ${mqc_config} --cl-config '${intro}' .
        """
    
    stub:
        """
        touch multiqc_report.html
        """
}