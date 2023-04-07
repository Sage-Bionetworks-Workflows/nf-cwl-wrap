// Ensure DSL2
nextflow.enable.dsl = 2

//url for example CWL workflow
params.cwl_file = "https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/develop/EPIC/workflow/steps/epic/epic.cwl"
//example params file
params.input_file = "${projectDir}/example_inputs/epic.json"

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    containerOptions = '-v "/var/run/docker.sock:/var/run/docker.sock" -v /tmp:/tmp'
    container "ghcr.io/sage-bionetworks-workflows/nf-cwl-wrap:1.0"

    input:
    path cwl_file
    path input_file

    script:
    """
    #!/bin/sh
    
    cwltool ${cwl_file} ${input_file}
    """
}

workflow {
    ch_cwl_file = Channel.fromPath(params.cwl_file)
    ch_input_file = Channel.fromPath(params.input_file)
    EXECUTE_CWL_WORKFLOW(ch_cwl_file, ch_input_file)
}
