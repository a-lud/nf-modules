process busco_plot {
    tag { 'BUSCO plot' }
    publishDir "${outdir}/post-assembly-qc/busco", mode: 'copy'
    label "cores_mem_time_low"

    conda "$projectDir/conf/R.yaml"

    input:
        file summaries
        val outdir
    
    output:
        path "*.png"

    script:
        """
        busco-plot-updated.R
        """
}