process busco {
    tag { 'BUSCO' + stage + id }
    publishDir "${outdir}/busco", mode: 'copy'
    label "parallel_max_med"

    conda "$projectDir/conf/busco.yaml"

    input:
        tuple val(id), file(fasta)
        val buscoDB
        val stage
        val outdir
    
    output:
        path "${stage}-${id}"


    script:
        """
        ulimit -u 100000

        busco \
            -i ${fasta} \
            -o ${stage}-${id} \
            -m geno \
            -l ${buscoDB} \
            --cpu ${task.cpus} \
            -e 1e-10 \
            --out_path \$PWD \
            --tar
        """
}