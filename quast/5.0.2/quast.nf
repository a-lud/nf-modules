process quast {
    tag { 'QUAST' }
    publishDir "${outdir}/post-assembly-qc", mode: 'copy'
    label "parallel_low"

    conda "$projectDir/conf/quast.yaml"

    input:
        file fastas
        val outdir
        val scaffolds_checked
    
    output:
        path "quast/*"
    
    when:
        scaffolds_checked == true

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