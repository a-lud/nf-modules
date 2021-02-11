process absrel {
    tag { 'HyPhy - aBSREL' }
    publishDir "${outdir}/hyphy/absrel", mode: 'copy'
    label "parallel_low"

    input:
        tuple file(aln), file(tree)
        val outdir
        val absrel_optional

    output:
        file "*.json"

    script:
        def opt = absrel_optional ?: ''
        """
        parallel -j ${task.cpus} \\
        --joblog parallel_hyphy-aBSREL.log \\
        hyphy absrel --alignment {} --tree ${tree} --output aBSREL-{/.}_${tree.baseName}.json ${opt} ::: ${aln}
        """
}