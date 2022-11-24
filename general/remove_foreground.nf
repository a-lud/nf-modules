process remove_foreground {
    tag { tree.baseName }
    publishDir "${outdir}/logs", mode: 'copy', pattern: "${tree.baseName}-no-fg.log"
    
    stageInMode 'copy'
    conda "$projectDir/conf/ete3.yaml"

    input:
        file tree
        val outdir
    
    output:
        path "${tree.baseName}-no-fg.nwk", emit: no_fg
        path "${tree.baseName}-no-fg.log"

    script:
        """
        remove_foreground.py ${tree} ${tree.baseName}-tmp.nwk
        cat ${tree.baseName}-tmp.nwk | tr -d \\''\\' > ${tree.baseName}-no-fg.nwk
        
        mv .command.log ${tree.baseName}-no-fg.log
        """
}
