process coverage {
    tag { id }
    publishDir "${outdir}", mode: 'copy', pattern: "${id}-coverage.csv"
    label "bcftools_st"
    conda "$projectDir/conf/samtools.yaml"

    input:
        tuple val(id), file(bam), file(asm)
        val outdir
    
    output:
        tuple val(id), env(DPMAX), env(DPMIN), emit: covdepth
        path "${id}-coverage.csv"

    script:
        """
        # Subset FASTA for regions (if not using all sequences)
        samtools faidx ${asm}
        SIZE=\$(awk '{s+=\$2}END{print s}' ${asm.getName()}.fai)

        # Avg. coverage and Max/Min
        AVG=\$(samtools depth -a ${bam} | awk '{sum+=\$3} END { print sum/'\${SIZE}' }')
        DPMAX=\$(echo "\${AVG}*2" | bc)
        DPMIN=\$(echo "\${AVG}/3" | bc)

        # Breadth of coverage (i.e. how much of the genome is covered)
        BREADTH=\$(samtools depth -a ${bam} | awk '{if(\$3>0) total+=1} END { print (total/'\${SIZE}') * 100 }')

        # Write an output file
        echo "file,reference,average,min,max,breadth" > ${id}-coverage.csv
        echo "${id},${asm.baseName},\$AVG,\$DPMIN,\$DPMAX,\$BREADTH" >> ${id}-coverage.csv
        """
}