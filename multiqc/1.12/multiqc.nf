process multiqc {
    tag { 'Report' }
    publishDir "${outdir}", mode: 'move'

    conda "$projectDir/conf/multiqc.yaml"

    input:
        file files
        path mqc_config
        val intro
        val outdir
    
    output:
        path "multiqc_report.html"

    script:
        // multiqc --config ${projectDir}/conf/multiqc-configs/multiqc-config.yaml --cl_config '${intro}' .
        """
        multiqc --config ${mqc_config} --cl_config '${intro}' .
        """
    
    stub:
        """
        touch multiqc_report.html
        """
}