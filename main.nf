// Ensure DSL2
nextflow.enable.dsl = 2

//url for exmaple CWL workflow
params.cwl_file = "example/example.cwl"
//example params file
params.input_file = "example/inputs.yaml"

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    containerOptions = '--entrypoint "" -v "/var/run/docker.sock:/var/run/docker.sock" -v /tmp:/tmp'
    container "quay.io/commonwl/cwltool:3.1.20230213100550"

    secret "SYNAPSE_AUTH_TOKEN"

    debug true

    input:
    path cwl_file
    path input_file

    script:
    """
    #!/bin/sh

    cwltool ${cwl_file} ${input_file} > output.txt
    """
}

workflow {
    ch_cwl_file = Channel.fromPath(params.cwl_file)
    ch_input_file = Channel.fromPath(params.input_file)
    EXECUTE_CWL_WORKFLOW(ch_cwl_file, ch_input_file)
}
