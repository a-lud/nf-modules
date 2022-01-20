process pin_hic {
    tag { 'pin_hic - ' + id }
    publishDir "${outdir}/scaffold-hic/${id}", mode: 'copy'
    label "singleCore_high"

    input:
        tuple val(id), file(haplotype), file(bam)
        val outdir
    
    output:
        tuple val(id), path("${id}.scaffolds_final.fa"), path("${id}.scaffolds_final.fa.fai"), emit: scaffolds
        path "*.wig", emit: wig
        path "*.sat", emit: sat
        path "*.mat", emit: mat
    script:
        """
        pin_hic \
		    -O . \
		    -q 20 \
		    -x ${haplotype}.fai \
		    -r ${haplotype} \
		    ${bam}

        mv scaffolds_final.fa ${id}.scaffolds_final.fa
        mv scaffolds_final.fa.fai ${id}.scaffolds_final.fa.fai
        """
}