process prot_to_codon_msa {
    publishDir "${outdir}", mode: 'copy', pattern: "msa-to-codon"
    publishDir "${outdir}/logs/msa-to-codon", mode: 'copy', pattern: "msa_to_codon.log"
    publishDir "${outdir}/logs/msa-to-codon", mode: 'copy', pattern: "**/pal2nal.log"
    label "msa2codon"

    conda "$projectDir/conf/msa2codon.yaml"

    input:
        file nucl
        file msa_dir
        val outdir
    
    output:
        path "msa-to-codon"
        path "msa-to-codon/codon_alignments", emit: msa_codon
        path "**.log"

    script:
        """
        mkdir -p nucl
        mv *.cds nucl

        protMsaToCodonMsa.py \
            --fasta \$PWD/nucl \
            --msa ${msa_dir} \
            --outdir \$PWD/msa-to-codon

        cp .command.log msa_to_codon.log
        """
}
