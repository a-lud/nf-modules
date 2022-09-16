process compareLRT {

    publishDir "${outdir}", mode: 'copy', pattern: "lrt-pval-comparison.csv"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "compareLRT.log"
    
    conda "$projectDir/conf/etetools.yaml"
    // label 'ete'

    input:
        file foreground
        file dropout
        val outdir

    output:
        file "lrt-pval-comparison.csv"
        file "compareLRT.log"

    script:
        """
        ${projectDir}/bin/eteTools/compareLRT.py \
            ${foreground}/lrt.csv \
            ${dropout}/lrt.csv \
            lrt-pval-comparison.csv

        cp .command.log compareLRT.log
        """        
}