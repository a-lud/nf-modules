process hifiasm {
    tag { 'hifiasm ' + id }
    publishDir "${outdir}/assembly-contigs/${id}", mode: 'copy'
    label "hifiasm"

    conda "$projectDir/conf/hifiasm.yaml"

    input:
        tuple val(id), file(fastq)
        val outdir
    
    output:
        path "*"
        tuple val (id), file("${id}.fa"), emit: contigs

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus}
            ${fastq}
        
        gfatools gfa2fa -l 80 ${id}.p_ctg.gfa > ${id}.fa
        """
}