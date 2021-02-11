process absrel {
    tag { 'HyPhy - RELAX' }
    publishDir "${outdir}/hyphy/relax", mode: 'copy'
    label "parallel_low"

    input:
        tuple file(aln), file(tree)
        val outdir
        val relax_optional

    output:
        file "*.json"

    script:
        def opt = relax_optional ?: ''
        """
        parallel -j ${task.cpus} \\
        --joblog parallel_hyphy-RELAX.log \\
        hyphy relax --alignment {} --tree ${tree} --output RELAX-{/.}_${tree.baseName}.json ${opt} ::: ${aln}
        """
}