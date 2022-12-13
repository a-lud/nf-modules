process bcftools_vcfutils {
    tag { id }
    publishDir enabled: false
    label "consensus"
    conda "$projectDir/conf/bcftools.yaml"

    input:
        tuple val(id), path(vcf), path(regions)
        
    output:
        tuple val(id), path("${id}.fastq.gz")
        
    script:
        def reg = regions.getName() != "EMPTY" ? "--regions-file ${regions}" : ''
        """
        bcftools view ${reg} ${vcf} | vcfutils.pl vcf2fq | bgzip > ${id}.fq.gz
        """
    
    stub:
        def reg = regions.getName() != "EMPTY" ? "--regions-file ${regions}" : ''
        """
        echo "bcftools view ${reg} ${vcf} | vcfutils.pl vcf2fq | bgzip > ${id}.fq.gz"
        touch ${id}.fastq.gz
        """
}
