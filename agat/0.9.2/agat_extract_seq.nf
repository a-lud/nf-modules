process agat_extract_seq {
    tag { id }
    publishDir "${outdir}/agat/cds_proteins", mode: 'copy', pattern: "${id}.faa"
    publishDir "${outdir}/agat/cds_nucleotide", mode: 'copy', pattern: "${id}.cds"
    publishDir "${outdir}/logs", mode: 'copy', pattern: "*-${id}.log"
    label "agat"

    conda "$projectDir/conf/agat.yaml"

    input:
        tuple val(id), 
              file(gff),
              file(asm)
        val outdir
    
    output:
        path "${id}.faa", emit: protein
        path "${id}.cds", emit: nucleotide
        path "*"

    script:
        """
        agat_sp_extract_sequences.pl \
            --clean_final_stop \
            --clean_internal_stop \
            --fasta ${asm} \
            --gff ${gff} \
            --output ${id}.faa \
            --protein \
            --type cds

        agat_sp_extract_sequences.pl \
            --clean_final_stop \
            --clean_internal_stop \
            --fasta ${asm} \
            --gff ${gff} \
            --output ${id}.cds \
            --type cds
        
        cp .command.log agat-extract-${id}.log
        """
}