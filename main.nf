// Ensure DSL2
nextflow.enable.dsl = 2

params.s3_file = "s3://iatlas-project-tower-bucket/s3_file.csv"
//url for example CWL workflow
params.cwl_file = "https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/develop/Immune_Subtype_Clustering/workflow/steps/immune_subtype_clustering/immune_subtype_clustering.cwl"

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    debug true
    // containerOptions only work when run locally, aws batch volume mounting in nextflow.config for Tower runs
    containerOptions = '-v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp -v \$PWD:/input'
    container "ghcr.io/sage-bionetworks-workflows/nf-cwl-wrap:latest"

    input:
    path cwl_file
    tuple path(input_file), path(data_file)

    output:
    path "**"

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
    EXECUTE_CWL_WORKFLOW(params.cwl_file, file_ch)
}
