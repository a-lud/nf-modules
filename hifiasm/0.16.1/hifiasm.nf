process hifiasm {
    tag { 'hifiasm ' + id }
    publishDir "${outdir}/assembly-contigs/${id}", mode: 'copy'
    label "cores_max_mem_time_high"

    conda "$projectDir/conf/hifiasm.yaml"

    input:
        tuple val(id), file(fastq)
        val outdir
    
    output:
        path "*"
        tuple val (id), file("${id}.fa"), emit: fa

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus}
            ${fastq}
        
        gfatools gfa2fa -l 80 ${id}.p_ctg.gfa > ${id}.fa
        """
}