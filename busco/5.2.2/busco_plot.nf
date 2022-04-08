process busco_plot {
    tag { 'BUSCO plot' }
    publishDir "${outdir}/post-assembly-qc/busco", mode: 'copy'
    label "cores_mem_time_low"

    conda "$projectDir/conf/R.yaml"

    input:
        file summaries
        val outdir
        val scaffolds_checked
    
    output:
        path "*.png"

    when:
        scaffolds_checked == true

    script:
        """
        busco-plot-updated.R
        """
}