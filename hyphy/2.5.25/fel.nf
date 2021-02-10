process fel {
    tag { 'HyPhy - FEL' }
    publishDir "${outdir}/hyphy/fel", mode: 'copy'
    label "parallel_low"

    input:
        // file aln
        // file tree
        tuple file(aln), file(tree)
        val outdir
        val fel_optional

    output:
        file "FEL.json"

    script:
        def opt = fel_optional ?: ''
        """
        echo "parallel -j ${task.cpus} \\
        --joblog parallel_hyphy-FEL.log \\
        hyphy fel --alignment {} --tree ${tree} ${opt} ::: ${aln}" > FEL.json
        """
}