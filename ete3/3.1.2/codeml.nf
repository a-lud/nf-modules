process codeml {
    tag { id }

    publishDir "${outdir}", mode: 'copy'
    
    conda "$projectDir/conf/ete3.yaml"
    label 'ete'
    cpus { models.tokenize(' ').size() }

    input:
        tuple val(id), file(alignment), file(tree)
        val models
        val outdir

    output:
        path "ete-out/${id}", emit: cml

    script:
        """
        # Initial run of M0 to get initial starting branch lengths
        ete3 evol \
            --alg ${alignment} \
            -t ${tree} \
            --models M0 \
            --cpu 1 \
            -o initial-M0

        # Get initial output file
        O=\$(find initial-M0 -type f -name 'out')

        # Parse out M0 tree
        grep "^(.*;\$" \$O | tail -n 1 > m0.nw

        # Add M0 branch lengths to tree, preserving marking
        add_branchlengths.py ${tree} m0.nw marked-branch-lengths.nw

        # Run user models
        ete3 evol \
            --alg ${alignment} \
            -t marked-branch-lengths.nw \
            --models ${models} \
            --cpu ${task.cpus} \
            -o ete-out/${id} \
            -v 1
        
        # remove files from working directory to reduce system clutter
        FLS='2NG.dN 2NG.dS 2NG.t 4fold.nuc algn lnf rst1 rub tmp.ctl tree'
        for F in \$FLS; do
            find ete-out/${id} -type f -name \$F -delete
        done

        rm -r initial-M0 m0.nw marked-branch-lengths.nw .command.err .command.log .command.out .command.begin .command.sh
        """        
}