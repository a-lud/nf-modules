process salsa2 {
    tag { "SALSA2 ${id}" }
    publishDir "${outdir}/assembly-scaffold/salsa2-${id}", mode: 'copy'
    label "scaffolding"

    conda "$projectDir/conf/salsa2.yaml"

    input:
        tuple val(id), 
              file(ctg), 
              file(fai), 
              file(bam)
        val outdir
    
    output:
        tuple val(id), file('scaffolds_FINAL.fasta'), emit: scaffolds
        tuple val(id), path("scaffolds_FINAL.agp"), emit: juicebox
        
    script:
        """
        bedtools bamtobed -i ${bam} > ${bam.baseName}.bed
        run_pipeline.py \
            -a ${ctg} \
            -l ${fai} \
            -b ${bam.baseName}.bed \
            -o salsa-out \
            -e 'GATC,GANTC,CTNAG,TTAA' \
            -m yes || exit 1

        rm ${bam.baseName}.bed
        cp salsa-out/scaffolds_FINAL* \$PWD
        """
}
