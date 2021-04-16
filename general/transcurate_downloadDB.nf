process downloadDB {
    tag { 'Download Databases' }
    publishDir "${outdir}/databases", mode: 'copy'
    label "parallel_low"

    input:
        val outdir
    
    output:
        path "${outdir}/databases", emit: database_dir

    script:
        """
        wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
        gunzip uniprot_sprot.fasta.gz
        makeblastdb \
            -in uniprot_sprot.fasta \
            -input_type fasta \
            -dbtype prot \
            -parse_seqids

        wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
        gunzip Pfam-A.hmm.gz
        hmmpress Pfam-A.hmm
        """
}