process agat_longest_iso {
    tag { id }
    publishDir "${outdir}/agat/longest-isoforms", mode: 'copy', pattern: "*-longest.gff3"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "*-${id}.log"
    label "agat"

    conda "$projectDir/conf/agat.yaml"

    input:
        tuple val(id), file(gff)
        val outdir
    
    output:
        tuple val(id), 
              path("${id}-longest.gff3"), emit: longest
        path "*"

    script:
        """
        agat_sp_keep_longest_isoform.pl \
            --gff ${gff} \
            --output ${id}-longest.gff3

        cp .command.log agat-longest_isoform-${id}.log
        """
}