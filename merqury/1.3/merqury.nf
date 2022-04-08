process merqury {
    tag { 'Merqury K-mer' }
    publishDir "${outdir}/post-assembly-qc/merqury", mode: 'copy'
    label 'cores_max_mem_time_med'

    conda "$projectDir/conf/merqury.yaml"

    input:
        tuple file(fastas), val(id_hifi), file(hifi)
        val outdir
        val scaffolds_checked
    
    output:
        path "*.{ploidy,hist,filt,png,qv,stats,bed,wig}"
    
    when:
        scaffolds_checked == true

    script:
        """
        cp ${projectDir}/bin/spectra-cn.sh \${MERQURY}/eval

        meryl count \
            k=21 \
            threads=${task.cpus} \
            memory=50 \
            ${hifi} \
            output reads.meryl

        merqury.sh reads.meryl ${fastas} genomes-to-${id_hifi}
        """
}