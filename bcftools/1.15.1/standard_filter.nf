process standard_filter {
    tag { id }
    publishDir "${outdir}", mode: 'move', pattern: "*filtered.vcf*"
    label "bcftools"

    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), file(regions), file(vcf), file(asm), val(dpmax), val(dpmin)
        val filteropt
        val viewopt
        val normopt
        val sortopt
        val outdir
        
    output:
        path "${id}.filtered.vcf*"
        
    script:
        def regopt = regions.baseName == 'no_regions' ? '' : "--regions-file ${regions}"
        def filter = (dpmax && dpmin) ? "-i \"DP>=${dpmin} & DP<=${dpmax}\"" : ""
        """
        bcftools filter \
            -Ou \
            ${regopt} \
            ${filter} \
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
            -o ${id}.filtered.vcf.gz \
            --temp-dir \$PWD \
            ${sortopt}

        tabix -p vcf ${id}.filtered.vcf.gz

        bcftools stats ${id}.filtered.vcf.gz > ${id}.filtered.vcf.stats
        """
}
