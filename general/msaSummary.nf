process msaSummary {
    stageInMode 'copy'
    publishDir "${outdir}/msa-summary", mode: 'copy', pattern: "${stage}-trimming"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "msaSummary-${stage}.log"

    input:
        file codon_dir
        val stage
        val outdir
    
    output:
        path "${stage}-trimming"
        path "msaSummary-${stage}.log"

    script:
        """
        mkdir -p ${stage}-trimming
        msaSummary \
            --msadir ${codon_dir} \
            --ext '.fa' \
            --csv ${stage}-trimming/${stage}-trimming.csv \
            --boxplot ${stage}-trimming/${stage}-trimming.png
        
        mv .command.log msaSummary-${stage}.log
        """
}
