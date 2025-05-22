// Ensure DSL2
nextflow.enable.dsl = 2

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    debug true
    secret "CONTAINER_REGISTRY_ACCESS_TOKEN"
    
    // containerOptions only work when run locally, aws batch volume mounting in nextflow.config for Tower runs
    containerOptions = '-v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp -v \$PWD:/input'
    container "ghcr.io/sage-bionetworks-workflows/nf-cwl-wrap:latest"

    input:
    path cwl_file
    tuple path(input_file), path(data_file)

    output:
    stdout
    path "**", optional: true

    script:
    """
    #!/bin/sh
    if [ -n "${params.registry_username}" ]; then
        echo \$CONTAINER_REGISTRY_ACCESS_TOKEN | docker login ${params.registry} -u ${params.registry_username} --password-stdin
    fi
    cwltool ${cwl_file} --input_file ${input_file} --data_file ${data_file}
    """
}

workflow {
    file_ch = Channel.fromPath(params.manifest)
                .splitCsv(header:true)
                .map { row -> tuple(row.input_file, row.data_file) }
    EXECUTE_CWL_WORKFLOW(params.cwl_file, file_ch)
}
