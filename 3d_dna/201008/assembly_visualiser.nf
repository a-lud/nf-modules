process assembly_visualiser {
    tag { "3D-DNA visualise ${id}" }
    publishDir "${outdir}/assembly-scaffold/${scafftool}-${id}/juicebox-files"
    label "..." //TODO: get a label sorted

    conda "$projectDir/conf/3ddna.yaml"

    input:
        tuple val(id), file(agp), file(links)
        val scafftool
        val outdir
    
    output:
        tuple path("${id}-${scafftool}.assembly"), path("${id}-${scafftool}.hic")
        
    script:
        """
        # the sorting step in the visualiser script uses a decent amount of memory
        export TMPDIR=\$PWD

        # Convert AGP file to '.assembly' file used by Juicer/Juicebox etc...
        agp2assembly.py ${agp} ${id}-${scafftool}.assembly
        
        run-assembly-visualizer.sh ${id}-${scafftool}.assembly out.sorted.links.txt # creates a .hic file
        """
}
