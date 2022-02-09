process hifiasm {
    tag { 'hifiasm - ' + id }
    publishDir "${outdir}/assembly-contigs/${id}", mode: 'copy'
    label "parallel_max_high"

    conda "$projectDir/conf/hifiasm.yaml"

    input:
        tuple val(id), file(fastq)
        val outdir
    
    output:
        path "${id}.p_ctg.gfa"
        tuple val (id), file("${id}.p_ctg.fa"), emit: fa

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus}
            ${fastq}
        
        awk '/^S/{print \">\"\$2;print \$3}' ${id}.p_ctg.gfa > ${id}.p_ctg.fa
        """
}