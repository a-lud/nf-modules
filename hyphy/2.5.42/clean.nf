process clean {
    publishDir enabled: false

    conda "$projectDir/conf/hyphy-2.5.42.yaml"

    input:
        path msa

    output:
        path "*.clean.fa"

    script:
        """
        # Clean sequences incase they still have internal stop codons
        for MSA in *.fa; do
            hyphy CLN Universal \${MSA} "No/No" \${MSA%.*}.clean.fa
        done

        for f in \$(find . -type l -name '*.fa'); do unlink \$f; done
        """

    stub:
        """
        for f in *.fa; do touch \${f%.*}.clean.fa; done
        """
}