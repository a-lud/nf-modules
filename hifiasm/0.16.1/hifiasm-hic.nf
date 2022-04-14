process hifiasm_hic {
    tag { 'hifiasm ' + id }
    publishDir "${outdir}/assembly-contigs/${id}", mode: 'copy'
    label "hifiasm"

    conda "$projectDir/conf/hifiasm.yaml"

    input:
        tuple val(id), file(fastq)
        tuple val(id_hic), file(hic)
        val outdir
    
    output:
        path '*'
        path '*.fa', emit: contigs

    script:
        """
        hifiasm \
            -o ${id} \
            -t ${task.cpus} \
            --h1 ${hic[0]} \
            --h2 ${hic[1]} \
            ${fastq}

        # Convert GFA outputs to FASTA format
        gfatools gfa2fa -l 80 ${id}.hic.hap1.p_ctg.gfa > ${id}-hap1.fa
        gfatools gfa2fa -l 80 ${id}.hic.hap2.p_ctg.gfa > ${id}-hap2.fa
        gfatools gfa2fa -l 80 ${id}.hic.p_ctg.gfa > ${id}-p_ctg.fa
        """
}
