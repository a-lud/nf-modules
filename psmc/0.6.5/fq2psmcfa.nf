process fq2psmcfa {
    tag { id }
    publishDir enabled: false
    label "psmc_helper"

    // TODO: Uncomment this
    // conda "$projectDir/conf/psmc.yaml"

    input:
        tuple val(id), file(fastq)
        
    output:
        tuple val(id), path("${id}.psmcfa")
        
    script:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5/utils'
        """
        ${dir}/fq2psmcfa -q 20 ${fastq} > ${id}.psmcfa
        """
    
    stub:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5/utils'
        """
        echo "${dir}/fq2psmcfa -q 20 ${fastq} > ${id}.psmcfa"
        touch ${id}.psmcfa
        """
}
