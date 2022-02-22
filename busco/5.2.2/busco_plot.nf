process busco_plot {
    tag { 'BUSCO plot' }
    publishDir "${outdir}/post-assembly-qc/busco-figure", mode: 'copy'
    label "cores_mem_time_low"

    conda "$projectDir/conf/busco.yaml"

    input:
        file summaries
        val outdir
    
    output:
        path "*.png"

    script:
        """
        generate_plot.py -wd .
        """
}