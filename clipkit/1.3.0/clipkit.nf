process clipkit {
    publishDir "${outdir}", mode: 'copy', pattern: "clipkit"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "*.log"

    label 'clipkit'

    conda "$projectDir/conf/clipkit.yaml"

    input:
        file codon_dir
        val outdir
    
    output:
        path "clipkit", emit: clean
        path "*.log"

    script:
        """
        mkdir -p clipkit
        for FA in ${codon_dir}/*.fa; do
            BN=\$(basename \$FA)
            clipkit \$FA --output clipkit/\$BN
        done

        mv .command.log clipkit.log
        """
}
