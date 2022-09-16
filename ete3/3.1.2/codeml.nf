process codeml {
    tag { id }

    publishDir "${outdir}", mode: 'copy', pattern: "ete-out/${id}"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "codeml-${id}.log"
    
    conda "$projectDir/conf/ete3.yaml"
    label 'ete'

    input:
        tuple val(id), file(alignment), file(tree)
        val models
        val outdir

    output:
        path "ete-out/${id}", emit: cml
        file "codeml-${id}.log"

    script:
        """
        ete3 evol \
            --alg ${alignment} \
            -t ${tree} \
            --models ${models} \
            --cpu ${task.cpus} \
            -o ete-out/${id} \
            -v 1
        
        cp .command.log codeml-${id}.log
        """        
}