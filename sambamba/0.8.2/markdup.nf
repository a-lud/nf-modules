process markdup {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}.bam"
    publishDir "${outdir_sambamba}", mode: 'copy', pattern: '*.sambamba'
    label "markdup"

    conda "$projectDir/conf/sambamba.yaml"

    input:
        tuple val(id),
              file(bam)
        val outdir
        val outdir_sambamba
    
    output:
        tuple val(id), path("${id}.{bam,bam.bai}"), emit: bam
        path "${id}.sambamba", emit: multiqc
        
    script:
        """
        # Mark duplicates
        sambamba markdup \
            -t ${task.cpus} \
            --tmpdir=\$PWD \
            -l 9 \
            ${bam} \
            ${id}.bam &> ${id}.sambamba
        """
}
