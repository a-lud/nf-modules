process codeml {
    tag { id }

    publishDir "${outdir}", mode: 'copy', pattern: "*.{rst,out}"
    // publishDir "${outdir}/logs", mode: 'copy', pattern: "codeml-${id}.log"
    
    conda "$projectDir/conf/ete3.yaml"
    label 'ete'

    input:
        tuple val(id), file(alignment), file(tree)
        val models
        val outdir

    output:
        path "ete-out/${id}", emit: cml
        file "*.{out,rst}"
        // file "codeml-${id}.log"

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
        add_branchlenghts.py ${tree} m0.nw marked-branch-lengths.nw

        # Run user models
        ete3 evol \
            --alg ${alignment} \
            -t marked-branch-lengths.nw \
            --models ${models} \
            --cpu ${task.cpus} \
            -o ete-out/${id} \
            -v 1
        
        # remove files from working directory to reduce system clutter
        DIRS='2NG.dN 2NG.dS 2NG.t 4fold.nuc algn lnf rst1 rub tmp.ctl tree'
        for D in \$DIRS; do
            find ete-out/${id} -type f -name \$D -delete
        done

        # Rename and move output files to current directory
        find ete-out -type f -exec bash -c 'MODEL=\$(basename \$(dirname \$1)); MODEL=\$(echo \$MODEL | cut -d "." -f 1 | cut -d "~" -f 1 ); FILE=\$(basename \$1); cp \$1 ${id}-\$MODEL.\$FILE' shell {} \\;
        
        cp .command.log codeml-${id}.log
        """        
}