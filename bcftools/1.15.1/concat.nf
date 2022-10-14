process concat {
    // tag { "Cat VCFs" }
    // publishDir enabled: false
    // publishDir "${outdir}/consensus", mode: 'move', pattern: "*.{fa,stats}"
    publishDir "${outdir}", mode: 'move', pattern: "${id}.vcf.gz"

    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), file(vcfs), file(idx)
        val outdir
        
    output:
        path "${id}.vcf.gz", emit: vcf
        
    script:
        """
        bcftools concat -o ${id}.vcf.gz ${vcfs}
        """
}
