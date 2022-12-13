process splitfa {
    tag { id }
    publishDir enabled: false
    label "psmc_helper"

    // TODO: Uncomment this
    // conda "$projectDir/conf/psmc.yaml"

    input:
        tuple val(id), file(psmcfa)
        
    output:
        tuple val(id), path("${id}-split.psmcfa")
        
    script:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5/utils'
        """
        ${dir}/splitfa ${psmcfa} > ${id}-split.psmcfa
        """
    
    stub:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5/utils'
        """
        echo "${dir}/splitfa ${psmcfa} > ${id}-split.psmcfa"
        touch ${id}-split.psmcfa
        """
}
