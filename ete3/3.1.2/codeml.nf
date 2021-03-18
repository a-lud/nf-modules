process codeml {
    tag { id }

    publishDir "${outdir}/codeml/${id}", mode: 'copy'
    conda "$projectDir/conf/ete.yaml"

    input:
        tuple val(id), file(alignment), file(tree)
        val models
        val tests
        val codemlOptional

    output:
        file "out"
        file "tmp.ctl"
        file "results_codeml.txt"

    script:
        
        // Defining arguments
        def tests = tests ? '--tests ' + tests : ''
        def opt_args = codemlOptional ?: ''

        """
        ete3 evol \
            --cpu ${task.cpus} \
            -t ${tree} \
            --alg ${alignment} \
            -o \${PWD} \
            --models ${models} \
            ${tests} ${opt_args}
        
        cp .command.out results_codeml.txt
        """        
}