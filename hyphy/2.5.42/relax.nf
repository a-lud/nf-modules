process relax {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "*.json"
    publishDir "${logdir}", mode: 'copy', pattern: "*.{log,md}"

    errorStrategy 'ignore'

    conda "$projectDir/conf/hyphy-2.5.42.yaml"

    input:
        tuple val(id), path(msa), file(tree)
        val testlab
        val outdir
        val logdir

    output:
        file "*.{json,log,md}"

    script:
        """
        # Clean sequence of internal stop codons
        hyphy CLN Universal ${msa} "No/No" ${id}.clean.fa &> ${id}-clean.log

        # RELAX analysis
        hyphy relax CPU=1 \
            --alignment ${id}.clean.fa \
            --tree ${tree} \
            --test ${testlab} \
            --output ${id}-RELAX.json &> ${id}-RELAX.md

        rm ${id}.clean.fa
        """
}