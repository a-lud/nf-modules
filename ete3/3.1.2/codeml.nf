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
        
        # remove files from working directory to reduce system clutter
        DIRS='2NG.dN 2NG.dS 2NG.t 4fold.nuc algn lnf rst1 rub tmp.ctl tree'
        for D in \$DIRS; do
            find ete-out/${id} -type f -name \$D -delete
        done
        
        cp .command.log codeml-${id}.log
        """        
}