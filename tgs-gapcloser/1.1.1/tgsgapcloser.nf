process tgsgapcloser {
    tag { 'TGS-GapCloser ' + id }
    publishDir "${outdir}/assembly-gapClosed/${id}", mode: 'copy'
    label "cores_max_mem_time_high"

    conda "$projectDir/conf/tgsgapcloser.yaml"

    input:
        tuple val(id), file(fasta), file(hifi)
        val outdir
    
    output:
        tuple val(id), path("${id}.fa"), emit: scaff_detailed
        path "${id}.fa", emit: scaff
        path "*.{log,paf,gap_fill_detail,name_map,original_scaff_infos,updated_scaff_infos}"

    script:
        """
        EX=\$(which tgsgapcloser)
        sed -i 's/MINIMAP2_PARAM=\" -x ava-pb \"/MINIMAP2_PARAM=\" -x map-hifi \"/' \${EX}
        
        tgsgapcloser \
            --scaff ${fasta} \
            --reads ${hifi} \
            --output ${id}-tgs \
            --ne \
            --tgstype pb \
            --thread ${task.cpus}

        mv ${id}-tgs.scaff_seqs ${id}.fa
        """
}