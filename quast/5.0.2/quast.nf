process quast {
    tag { 'QUAST' }
    publishDir "${outdir}/post-assembly-qc", mode: 'copy'
    label "quast"

    conda "$projectDir/conf/quast.yaml"

    input:
        file fastas
        val outdir
    
    output:
        path "quast/*"


    script:
        """
        quast \
            --output-dir quast \
            --threads ${task.cpus} \
            --split-scaffolds \
            --eukaryote \
            --plots-format png \
            --no-icarus \
            ${fastas}
        """
}