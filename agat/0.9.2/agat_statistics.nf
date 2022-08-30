process agat_statistics {
    tag { id }
    publishDir "${outdir}/agat_statistics", mode: 'copy', pattern: "*.statistics"
    publishDir "${outdir}/logs/agat_statistics", mode: 'copy', pattern: "*-${id}.log"
    label "agat"

    conda "$projectDir/conf/agat.yaml"

    input:
        tuple val(id), 
              file(gff),
              file(asm)
        val outdir
    
    output:
        tuple val(id), 
              path("${id}.statistics")
        path "*"

    script:
        """
        agat_sp_statistics.pl \
            --gff ${gff} \
            --gs ${asm} \
            --output ${id}.statistics

        cp .command.log agat-statistics-${id}.log
        """
}