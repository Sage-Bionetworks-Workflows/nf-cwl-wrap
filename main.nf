// Ensure DSL2
nextflow.enable.dsl = 2

params.s3_file = "s3://bwmac-nextflow-test-bucket/s3_file.csv"
//url for example CWL workflow
params.cwl_file = "https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/develop/Immune_Subtype_Clustering/workflow/steps/immune_subtype_clustering/immune_subtype_clustering.cwl"
//example params file
// params.input_file = "${projectDir}/example_inputs/epic.json"


process STAGE_INPUTS {
    debug true

    input:
    tuple path(input_file), path(data_file)

    output:
    path input_file

    script:
    """
    mkdir -p \$PWD/input
    mv ${input_file} \$PWD/input/
    mv ${data_file} \$PWD/input/
    """
}

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    // containerOptions only work when run locally, aws batch volume mounting in nextflow.config for Tower runs
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
    file_ch = Channel.fromPath(params.s3_file)
                .splitCsv(header:true)
                .map { row -> tuple(row.input_file, row.data_file) }
    STAGE_INPUTS(file_ch)
    // ch_cwl_file = Channel.fromPath(params.cwl_file)
    // ch_input_file = Channel.fromPath(params.input_file)
    // EXECUTE_CWL_WORKFLOW(ch_cwl_file, ch_input_file)
}
