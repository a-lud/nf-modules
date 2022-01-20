process hifiasm {
    tag { 'hifiasm - ' + id }
    publishDir "${outdir}/hifiasm", mode: 'copy'

    cpus 30
    time '24h'
    memory '100 GB'

    input:
        tuple val(id), file(fastq)
        val outdir
    
    output:
        tuple val(id), path("${id}.p_ctg.gfa"), emit: primary_ctg

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus}
            ${fastq}
        """
}