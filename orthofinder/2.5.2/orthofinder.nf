process orthofinder {
    tag { prog }
    publishDir "${outdir}", mode: 'copy', pattern: "orthofinder"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "orthofinder_${prog}.log"
    label "ortho"

    conda "$projectDir/conf/orthofinder.yaml"

    input:
        file proteins
        val prog
        val stop_early
        val trim_msa
        val outdir
    
    output:
        path "orthofinder", type: 'dir', emit: orthofinder_all
        path "msa-single_copy_orthologs", type: 'dir', emit: msa
        path "orthofinder-${prog}.log"

    script:
        """
        mkdir -p msa-single_copy_orthologs
        mkdir -p prots

        # Move proteins to directory
        mv *.faa prots

        orthofinder \
            -f ./prots \
            -t ${task.cpus} \
            -S ${prog} \
            -n ${prog} \
            -M 'msa' \
            -o \$PWD/orthofinder \
            ${trim_msa} \
            ${stop_early}

        # Copy single copy ortholog MSA files only
        for SCO in orthofinder/Results_${prog}/Single_Copy_Orthologue_Sequences/*.fa; do
            BN=\$(basename \$SCO)
            cp orthofinder/Results_${prog}/MultipleSequenceAlignments/\${BN} msa-single_copy_orthologs
        done
        
        cp .command.log orthofinder-${prog}.log
        """
}
