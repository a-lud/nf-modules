process absrel {
    tag { 'HyPhy - BUSTED' }
    publishDir "${outdir}/hyphy/busted", mode: 'copy'
    label "parallel_low"

    input:
        tuple file(aln), file(tree)
        val outdir
        val busted_optional

    output:
        file "*.json"

    script:
        def opt = busted_optional ?: ''
        """
        parallel -j ${task.cpus} \\
        --joblog parallel_hyphy-BUSTED.log \\
        hyphy busted --alignment {} --tree ${tree} --output BUSTED-{/.}_${tree.baseName}.json ${opt} ::: ${aln}
        """
}