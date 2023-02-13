// Ensure DSL2
nextflow.enable.dsl = 2

//url for exmaple CWL workflow
params.cwl_url = "https://github.com/CRI-iAtlas/iatlas-workflows/blob/develop/Cibersort/workflow/iatlas_workflow/api_workflow.cwl"
//params for example workflow
params.cwl_params = "test: param"

//runs cwl workflow using url and params provided
process CWL_WORKFLOW {
    container "quay.io/commonwl/cwltool:3.1.20230213100550"

    secret "SYNAPSE_AUTH_TOKEN"

    input:
    tuple val(cwl_url), val(cwl_params)

    output:

    script:
    """
    echo ${cwl_url}
    echo ${cwl_params}
    """
}

workflow {
    CWL_WORKFLOW(params.cwl_url, params.cwl_params)
}
