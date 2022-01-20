process bwa_mem2_mem {
    tag { "bwa_mem2_mem - ${id_haplotype} ${id_hic}" }
    publishDir "${outdir}/scaffold-hic/${id_haplotype}", mode: 'copy'
    label "parallel_med"

    input:
        tuple val(id_haplotype), 
              file(haplotype), 
              file(fai), 
              file(bwa_idx),
              val(id_hic),
              file(reads)
        val outdir
    
    output:
        tuple val(id_haplotype), file(haplotype), file("*.bam"), emit: bam
    script:
        """
        bwa-mem2 mem \
		    -SP \
		    -B 10 \
		    -t ${task.cpus} \
		    ${haplotype} \
		    ${reads} | samtools view -b - > ${id_haplotype}-${id_hic}-hic.bam
        """
}