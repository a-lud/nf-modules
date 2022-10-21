process joint_mpileup_call {
    tag { chr ?: id }
    publishDir "${outdir}", mode: 'copy', pattern: "*.vcf.stats"
    label "bcftools"

    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), file(bams), file(bai),
              file(bamlist), file(asm),
              val(chr), file(regions)
        val vcftype
        val mapq
        val baseq
        val ploidy
        val mpileupopt
        val callopt
        val outdir

    output:
        tuple val(id), val(chr), 
              path(regions), path("*.vcf.gz*"), 
              file(asm), emit: vcf
        path "*vcf.stats"
        
    script:

        def vcftype = vcftype == 'variant' ? "--variants-only" : ""
        def regopt = regions.baseName != 'no_regions' ? "--regions-file ${regions}" : ""
        def rhc = chr ?: ''
        
        """
        bcftools mpileup \
            --bam-list ${bamlist} \
            -q ${mapq} \
            -Q ${baseq} \
            -Ou \
            -f ${asm} \
            -a DP,AD \
            ${regopt} \
            ${mpileupopt} |
        bcftools call \
            -m \
            ${vcftype} \
            --ploidy ${ploidy} \
            -Oz \
            -a FORMAT/GQ \
            -o ${id}${rhc}.vcf.gz \
            ${callopt}

        # Create summary file
        bcftools stats ${id}${rhc}.vcf.gz > ${id}${rhc}.vcf.stats

        tabix -p vcf ${id}${rhc}.vcf.gz
        """
}


