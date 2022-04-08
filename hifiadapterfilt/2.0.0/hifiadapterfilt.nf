process hifiadapterfilt {
    tag { "HifiAdapterFilt ${id}" }
    publishDir "${outdir}/adapter-removed-reads", mode: copy
    label "..." // TODO: work out resources

    conda "$projectDir/conf/hifiadapterfilt.yaml"

    input:
        tuple val(id), file(reads)
        val outdir
    
    output:
        tuple val(id), path("${id}.filt.fastq.gz"), emit: hifi_clean
        path "${id}.{blocklist,stats}"
        
    script:
        """
        hifiadapterfilt.sh \
            -p ${id} \
            -t ${task.cpus} \
            -o ${reads}
        """
}
