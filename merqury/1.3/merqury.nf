process merqury {
    tag { 'K-mer' }
    publishDir "${outdir}/post-assembly-qc/merqury", mode: 'copy'
    label 'merqury'

    conda "$projectDir/conf/merqury.yaml"

    input:
        tuple file(asm), file(hifi)
        val outdir
    
    output:
        path "*.{ploidy,hist,filt,png,qv,stats,bed,wig}"

    script:
        """
        cp ${projectDir}/bin/spectra-cn.sh \${MERQURY}/eval

        meryl count \
            k=21 \
            threads=${task.cpus} \
            memory=50 \
            ${hifi} \
            output reads.meryl

        merqury.sh reads.meryl ${asm} asm-to-hifi
        """
}