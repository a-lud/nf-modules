process standard_mpileup_call {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}.vcf.stats"
    label "bcftools"

    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), file(bam), file(bai),
              file(asm), file(regions)
        val vcftype
        val mapq
        val baseq
        val ploidy
        val mpileupopt
        val callopt
        val outdir

    output:
        tuple val(id), file(regions), path("${id}.vcf.gz*"), file(asm), emit: vcf
        path "${id}.vcf.stats"
        
    script:

        def vcftype = vcftype == 'variant' ? "--variants-only" : ""
        def regopt = regions.baseName == 'no_regions' ? '' : "--regions-file ${regions}"

        """
        bcftools mpileup \
            -q ${mapq} \
            -Q ${baseq} \
            -Ou \
            -f ${asm} \
            ${regopt} \
            ${mpileupopt} \
            ${bam} |
        bcftools call \
            -m \
            ${vcftype} \
            --ploidy ${ploidy} \
            -Oz \
            -a FORMAT/GQ \
            -o ${id}.vcf.gz \
            ${callopt}

        tabix -p vcf ${id}.vcf.gz

        bcftools stats ${id}.vcf.gz > ${id}.vcf.stats
        """
}
