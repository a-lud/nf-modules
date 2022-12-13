process psmc_write {
    tag { id }
    publishDir "${outdir}", mode: 'copy'

    input:
        tuple val(id), val(clock), path(files)
        val outdir
        
    output:
        path("${id}-*.psmc")
        
    script:
        """
        # Sanitize clock for filename
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        cat ${files} > ${id}-\$CLK.psmc
        """
    
    stub:
        def dir = '/home/a1645424/al/tools_AL/psmc-0.6.5'
        """
        # Sanitize clock for filename
        CLK=\$(echo ${clock} | sed 's/\\*/x/g;s/\\+/__/g')
        echo "cat ${files} > ${id}-\$CLK.psmc"
        touch ${id}-\$CLK.psmc
        """
}
