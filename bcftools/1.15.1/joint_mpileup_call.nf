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
              path("regions-subset.bed"), path("*.vcf.gz*"), 
              file(asm), emit: vcf
        path "*vcf.stats"
        
    script:

        def vcftype = vcftype == 'variant' ? "--variants-only" : ""
        def regopt = regions.baseName != 'no_regions' ? "--regions-file regions-subset.bed" : ""
        
        """
        # Filter regions file
        if [[ ${regions.baseName} != 'no_regions' ]]; then
            awk '{ if (\$1 == "${chr}") { print } }' ${regions} > regions-subset.bed
            ID="-${chr}"
        else 
            ID=""
            touch regions-subset.bed
        fi

        bcftools mpileup \
            --bam-list ${bamlist} \
            -q ${mapq} \
            -Q ${baseq} \
            -Ou \
            -f ${asm} \
            ${regopt} \
            ${mpileupopt} |
        bcftools call \
            -m \
            ${vcftype} \
            --ploidy ${ploidy} \
            -Oz \
            -a FORMAT/GQ \
            -o ${id}\$ID.vcf.gz \
            ${callopt}

        # Create summary file
        bcftools stats ${id}\$ID.vcf.gz > ${id}\$ID.vcf.stats

        tabix -p vcf ${id}\$ID.vcf.gz
        """
}


