process fastqc {
    tag { id }
    publishDir "${outdir}/${outprefix}/fastqc", mode: 'copy'
    label "fastqc"

    conda "$projectDir/conf/fastqc.yaml"

    input:
        tuple val(id), file(reads)
        val outprefix
        val outdir
    
    output:
        path "${id}_R{1,2}_fastqc.zip", emit: zip
        path "${id}_R{1,2}_fastqc.html"

    script:
        """
        fastqc \
            --outdir \$PWD \
            --noextract \
            --threads ${task.cpus} \
            ${reads}
        """
        
    stub:
        """
        touch "${id}.html"
        touch "${id}.zip"
        """
}