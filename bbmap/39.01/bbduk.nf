process bbduk {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "*-bbduk.log"
    label "bbduk"

    conda "$projectDir/conf/bbmap.yaml"

    input:
        tuple val(id), file(reads)
        path ref
        val k
        val mink
        val rcomp
        val ktrim
        val hdist
        val minlen
        val outdir
    
    output:
        tuple val(id), file("${id}-bb_R{1,2}.fastq.gz"), emit: fq
        path "${id}-bbduk.log", emit: log

    script:
        """
        bbduk.sh \
            in=${reads[0]} \
            in2=${reads[1]} \
            out=${id}-bb_R1.fastq.gz \
            out2=${id}-bb_R2.fastq.gz \
            ref=${ref} \
            k=${k} \
            mink=${mink} \
            rcomp=${rcomp} \
            ktrim=${ktrim} \
            hdist=${hdist} \
            minlength=${minlen} \
            threads=${task.cpus} &> ${id}-bbduk.log
        """
        
    stub:
        """
        touch ${id}-bb_R1.fastq.gz ${id}-bb_R1.fastq.gz ${id}-bbduk.log
        """
}