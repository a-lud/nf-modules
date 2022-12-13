process psmc {
    tag { id }

    // TODO: Change this to mode: 'copy'
    publishDir enabled: false
    label "psmc"

    // TODO: Uncomment this
    // conda "$projectDir/conf/psmc.yaml"

    input:
        tuple val(id), file(psmcfa), val(clock)
        // path outdir
        
    output:
        tuple val(id), val(clock), path("${id}*.psmc")
        
    script:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5'
        """
        # Sanitize clock for filename
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        ${dir}/psmc -p ${clock} -o ${id}-\${CLK}-0.psmc ${psmcfa}
        """
    
    stub:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5'
        """
        # Sanitize clock for filename
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        echo "${dir}/psmc -p ${clock} -o ${id}-\${CLK}-0.psmc ${psmcfa}"
        touch ${id}-\${CLK}-0.psmc
        """
}
