process joint_filter {
    tag { chr ?: id }
    publishDir "${outdir}", mode: 'copy', pattern: "*filtered.vcf.stats"
    label "bcftools"

    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), val(chr), file(regions), file(vcf), file(asm)
        val filteropt
        val viewopt
        val normopt
        val sortopt
        val outdir
        
    output:
        tuple val(id), path("*.filtered.vcf.gz*"), emit: vcf
        path "*.filtered.vcf.stats"
        
    script:

        def regopt = regions.baseName != 'no_regions' ? "--regions-file ${regions}" : ""
        def rhc = chr ?: ''
        
        """
       bcftools filter \
            -Ou \
            ${regopt} \
            ${filteropt} \
            ${vcf[0]} |
        bcftools view \
            -Ou \
            ${viewopt} |
        bcftools norm \
            -f ${asm} \
            -Ou \
            ${normopt} |
        bcftools sort \
            -Oz \
            -o ${id}${rhc}.filtered.vcf.gz \
            --temp-dir \$PWD \
            ${sortopt}

        tabix -p vcf ${id}${rhc}.filtered.vcf.gz

        bcftools stats ${id}${rhc}.filtered.vcf.gz > ${id}${rhc}.filtered.vcf.stats
        """
}
