process hifiasm_hic {
    tag { 'hifiasm - ' + id }
    publishDir "${outdir}/assembly-contigs/${id}", mode: 'copy'
    label "parallel_max_high"

    conda "$projectDir/conf/hifiasm.yaml"

    input:
        tuple val(id), file(fastq)
        tuple val(id_hic), file(hic)
        val outdir
    
    output:
        path "${id}.{hap1,hap2}.p_ctg.gfa", emit: gfa
        tuple file("${id}.hap1.fa"), file("${id}.hap2.fa"), emit: hap_fa

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus} \
            --h1 ${hic[0]} \
            --h2 ${hic[1]} \
            ${fastq}
        
        awk '/^S/{print \">\"\$2;print \$3}' ${id}.hap1.p_ctg.gfa > ${id}.hap1.fa
        awk '/^S/{print \">\"\$2;print \$3}' ${id}.hap2.p_ctg.gfa > ${id}.hap2.fa
        """
}
