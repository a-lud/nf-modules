process busted_ph {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}-BUSTED_PH.json"
    publishDir "${logdir}", mode: 'copy', pattern: "*.log"

    input:
        tuple val(id), path(msa), file(tree)
        val exedir
        val libpath
        val batchfile
        val testlab
        val outdir
        val logdir

    output:
        file "*.json"
        file "*.log"

    script:
        """
        # Clean sequences incase they have internal stop codons still
        ${exedir}/hyphy LIBPATH=${libpath} CLN Universal ${msa} "No/No" clean.fa &> cln.log

        ${exedir}/hyphy LIBPATH=${libpath} ${projectDir}/bin/hyphy-batch/${batchfile} \
            CPU=1 \
            --alignment clean.fa \
            --tree ${tree} \
            --output ${id}-BUSTED_PH.json \
            --srv No \
            --branches ${testlab} > ${id}-BUSTED_PH.log
        
        rm clean.fa
        """
}