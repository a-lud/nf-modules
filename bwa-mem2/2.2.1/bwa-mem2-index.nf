process bwa_mem2_index {
    tag { 'bwa_mem2_index - ' + id }
    publishDir "${outdir}/hifiasm/bwa-mem2-index", mode: 'copy'
    label "singleCore_low"

    conda "$projectDir/conf/bwa2.yaml"

    input:
        tuple val(id), file(haplotype)
        val outdir
    
    output:
        tuple val(id), file("*.{0123,ann,amb,64,pac}"), emit: bwa_idx
        tuple val(id), path("*.fai"), emit: fai
    script:
        """
        samtools faidx ${haplotype}
        bwa-mem2 index ${haplotype}
        """
}