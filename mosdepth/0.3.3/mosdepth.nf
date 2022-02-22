process mosdepth {
    tag { 'Mosdepth ' + id }
    publishDir "${outdir}/post-assembly-qc/mosdepth", mode: 'copy'
    label "parallel_low" // TODO: this can be pretty high core, low mem

    conda "$projectDir/conf/mosdepth.yaml"

    input:
        tuple val(id), file(fasta), file(bam), file(bai)
        val outdir
    
    output:
        path "*.txt"
        path "*.{gz,csi}"

    script:
        """
        mosdepth \
            -t ${task.cpus} \
            --fast-mode \
            --mapq 20 \
            ${fasta} \
            ${bam}
        """
}