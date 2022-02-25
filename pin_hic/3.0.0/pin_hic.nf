process pin_hic {
    tag { 'pin_hic - ' + id }
    publishDir "${outdir}/assembly-scaffold/${id}", mode: 'copy'
    label "cores_low_mem_time_high"

    input:
        tuple val(id), file(haplotype), file(fai), file(bam)
        val outdir
    
    output:
        tuple val(id), path("${id}.scaffold.fa"), emit: scaffolds
        path "*.{wig,sat,mat}"
        
    script:
        """
        pin_hic_it \
		    -O . \
		    -q 20 \
		    -x ${fai} \
		    -r ${haplotype} \
		    ${bam}

        mv scaffolds_final.fa ${id}.scaffold.fa
        """
}