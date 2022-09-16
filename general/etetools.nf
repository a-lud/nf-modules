process etetools {
    publishDir "${outdir}", mode: 'copy', pattern: "ete-${analysis}-summary"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "etetools-${analysis}-summary.log"
    
    conda "$projectDir/conf/etetools.yaml"
    // label 'ete'

    input:
        file etedirs
        val analysis
        val outdir

    output:
        path "ete-${analysis}-summary", emit: summary
        file "etetools-${analysis}-summary.log"

    script:
        """
        mkdir ete-inputs; mv ${etedirs} ete-inputs
        ${projectDir}/bin/eteTools/eteTools.py \
            ete-inputs \
            ete-${analysis}-summary

        cp .command.log etetools-${analysis}-summary.log
        """        
}