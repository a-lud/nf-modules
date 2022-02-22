process minimap2_pb_hifi {
    tag { 'Minimap2 ' + id }
    // publishDir "${outdir}/post-assembly-qc/mosdepth", mode: 'copy'
    publishDir enabled: false
    label "cores_max_mem_time_med"

    conda "$projectDir/conf/minimap2.yaml"

    input:
        tuple val(id), file(fasta), val(id_hifi), file(reads)
        val outdir
    
    output:
        tuple val(id), file(fasta), path("${id}-${id_hifi}.bam"), path("${id}-${id_hifi}.bam.bai")

    script:
        """
        minimap2 \
            -ax map-hifi \
            -t ${task.cpus} \
            ${fasta} \
            ${reads} | \
        samtools sort \
            -u | \
        samtools view \
            -b \
            -o ${id}-${id_hifi}.bam

        samtools index -@ ${task.cpus} ${id}-${id_hifi}.bam
        """
}