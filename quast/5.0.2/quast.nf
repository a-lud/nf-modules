process quast {
    tag { 'QUAST' + id }
    publishDir "${outdir}/quast", mode: 'copy'
    label "parallel_low"

    conda "$projectDir/conf/quast.yaml"

    input:
        tuple val(id), file(fasta)
        val outdir
    
    output:
        path "${id}-quast"

    script:
        """
        quast \
            --output-dir ${id}-quast \
            --threads ${task.cpus} \
            --split-scaffolds \
            --eukaryote \
            --plots-format png \
            --no-icarus \
            ${fasta}
        """
}