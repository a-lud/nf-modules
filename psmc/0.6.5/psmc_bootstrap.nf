process psmc_bootstrap {
    tag { id }
    publishDir enabled: false
    label "psmc_bootstrap"

    // TODO: Uncomment this
    // conda "$projectDir/conf/psmc.yaml"

    input:
        tuple val(id), file(spsmcfa), val(clock)
        
    output:
        tuple val(id), val(clock), path("${id}*.psmc")
        
    script:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5'
        """
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        seq 100 | xargs -n 1 -P ${task.cpus} -I {} ${dir}/psmc -p ${clock} -b -o ${id}-\${CLK}-{}.psmc ${spsmcfa} | sh
        """
    
    stub:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5'
        """
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        echo "seq 10 | xargs -n 1 -P ${task.cpus} -I {} touch ${id}-\${CLK}-{}.psmc | sh"
        seq 10 | xargs -n 1 -P 1 -I {} touch ${id}-\${CLK}-{}.psmc | sh
        """
}
