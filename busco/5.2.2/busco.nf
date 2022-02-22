process busco {
    tag { 'BUSCO ' + stage + ' ' + id }
    publishDir "${outdir}/post-assembly-qc", mode: 'copy'
    label "cores_mem_high_time_low"

    conda "$projectDir/conf/busco.yaml"

    input:
        tuple val(id), file(fasta)
        val buscoDB
        val stage
        val outdir
    
    output:
        path "busco-${stage}-${id}"
        path "busco-${stage}-${id}/short_summary*", emit: summary

    script:
        """
        ulimit -u 100000

        busco \
            -i ${fasta} \
            -o busco-${stage}-${id} \
            -m geno \
            -l ${buscoDB} \
            --cpu ${task.cpus} \
            --metaeuk_parameters="--disk-space-limit=10G,--remove-tmp-files=1" \
            --metaeuk_rerun_parameters="--disk-space-limit=10G,--remove-tmp-files=1" \
            --out_path \$PWD \
            --tar \
            --offline
        """
}