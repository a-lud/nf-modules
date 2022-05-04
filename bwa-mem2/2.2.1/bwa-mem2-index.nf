process bwa_mem2_index {
    tag { id }
    publishDir enabled: false

    label 'bwa_idx'

    conda "$projectDir/conf/bwa2.yaml"

    input:
        tuple val(id), file(asm)
        val outdir
    
    output:
        tuple val(id), file("*.{0123,ann,amb,64,pac}"), emit: bwa_idx
        tuple val(id), path("*.fai"), emit: fai
    script:
        """
        samtools faidx ${asm}
        bwa-mem2 index ${asm}
        """
}
