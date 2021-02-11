process slac {
    tag { 'HyPhy - SLAC' }
    publishDir "${outdir}/hyphy/slac", mode: 'copy'
    label "parallel_low"

    input:
        tuple file(aln), file(tree)
        val outdir
        val fubar_optional

    output:
        file "*.json"

    script:
        def opt = fubar_optional ?: ''
        """
        parallel -j ${task.cpus} \\
        --joblog parallel_hyphy-FUBAR.log \\
        hyphy slac --alignment {} --tree ${tree} --output SLAC-{/.}_${tree.baseName}.json ${opt} ::: ${aln}
        """
}