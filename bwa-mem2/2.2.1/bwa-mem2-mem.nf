process bwa_mem2_mem {
    tag { "${id_haplotype} ${id_hic}" }
    publishDir enabled: false // Don't need big bam file saved
    label "cores_max_mem_time_med"

    conda "$projectDir/conf/bwa2.yaml"

    input:
        tuple val(id_haplotype), 
              file(haplotype), 
              file(fai), 
              file(bwa_idx),
              val(id_hic),
              file(reads)
        val outdir
    
    output:
        tuple val(id_haplotype), file(haplotype), file(fai), file("*.bam"), emit: bam
        
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
