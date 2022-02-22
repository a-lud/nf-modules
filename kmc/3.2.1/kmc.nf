process kmc {
    tag { 'KMC' + id }
    publishDir "${outdir}/genome-size/kmc-${id}", mode: 'copy'
    label "cores_mem_high_time_med"

    conda "$projectDir/conf/kmc.yaml"
    
    input:
        tuple val(id), file(fastq)
        val outdir
    
    output:
        tuple val(id), path("${id}.kmc.histo"), path("${id}.{kmc_pre,kmc_suf}"), emit: histo

    script:
        """
        kmc \
            -k31 \
            -t${task.cpus} \
            -m64 \
            -ci2 \
            -cs100000 \
            ${fastq} ${id} .
        
        kmc_tools transform \
            ${id} \
            histogram \
            ${id}.kmc.histo \
            -ci2 \
            -cx100000
        """
}