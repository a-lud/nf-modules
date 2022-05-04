process mosdepth {
    tag { id }
    publishDir "${outdir}/post-assembly-qc/mosdepth", mode: 'copy'
    label "mosdepth"

    conda "$projectDir/conf/mosdepth.yaml"

    input:
        tuple val(id), file(asm), file(bam)
        val outdir
    
    output:
        path "*.{txt,gz,csi}"

    script:
        """
        mosdepth \
            -t ${task.cpus} \
            --fast-mode \
            --mapq 20 \
            ${id} \
            ${bam[0]}
        """
}