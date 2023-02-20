params.cwl_file = "example.cwl"
params.input_file = "inputs.yaml"

process RUN_CWL_WORKFLOW {
    containerOptions = '--entrypoint "" -v "/var/run/docker.sock:/var/run/docker.sock" -v /tmp:/tmp'
    container "quay.io/commonwl/cwltool:3.1.20230213100550"

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
    RUN_CWL_WORKFLOW(ch_cwl_file, ch_input_file)
}
