process bwa_mem2_index {
    tag { id }
    publishDir enabled: false

    label 'bwa_idx'

    conda "$projectDir/conf/bwa2.yaml"

    input:
        tuple val(id), file(asm)
    
    output:
        tuple val(id), 
              file(asm),
              file("*.{0123,ann,amb,64,pac}")
    script:
        """
        bwa-mem2 index ${asm}
        """
    stub:
        """
        touch ${asm}.fai ${asm}.0123 ${asm}.ann ${asm}.amb ${asm}.bwt.2bit.64 ${asm}.pac
        """
}
