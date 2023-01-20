process busted_ph {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}-BUSTED_PH.json"
    publishDir "${logdir}", mode: 'copy', pattern: "*.md"

    input:
        tuple val(id), path(msa), file(tree)
        val exedir
        val libpath
        val analysisdir
        val batchfile
        val testlab
        val outdir
        val logdir

    output:
        file "*.{json,md}"

    script:
        """
        # Clean sequences incase they have internal stop codons still
        ${exedir}/hyphy LIBPATH=${libpath} CLN Universal ${msa} "No/No" ${id}.clean.fa

        ${exedir}/hyphy LIBPATH=${libpath} ${analysisdir}/BUSTED-PH/${batchfile} \
            CPU=1 \
            --alignment ${id}.clean.fa \
            --tree ${tree} \
            --output ${id}-BUSTED_PH.json \
            --srv No \
            --branches ${testlab} > ${id}-BUSTED_PH.md
        
        rm ${id}.clean.fa
        """
}