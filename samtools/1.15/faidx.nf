process faidx {
    tag { id }
    publishDir enabled: false

    conda "$projectDir/conf/samtools.yaml"

    input:
        tuple val(id), file(asm)
    
    output:
        tuple val(id), path("${asm.getName()}.fai")

    script:
        """
        samtools faidx ${asm}
         """
    stub:
        """
        touch ${asm.getName()}.fai
        """
}