process joint_filter {
    tag { chr ?: id }
    // publishDir enabled: false
    // publishDir "${outdir}/consensus", mode: 'move', pattern: "*.{fa,stats}"
    publishDir "${outdir}", mode: 'move', pattern: "*filtered.vcf*"
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
        path "*.filtered.vcf*"
        
    script:
        """
        # Filter regions file
        if [[ -s ${regions} ]]; then
            ID="-${chr}"
            REGIONS="--regions-file ${regions}"
        else 
            ID=''
            REGIONS=''
        fi

        bcftools filter \
            -Ou \
            \${REGIONS} \
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
            -o ${id}\$ID.filtered.vcf.gz
            ${sortopt}

        tabix -p vcf ${id}\$ID.filtered.vcf.gz

        bcftools stats ${id}\$ID.filtered.vcf.gz > ${id}\$ID.filtered.vcf.stats
        """
}
