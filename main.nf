// Ensure DSL2
nextflow.enable.dsl = 2

//url for exmaple CWL workflow
params.cwl_file = "https://github.com/CRI-iAtlas/iatlas-workflows/blob/develop/Cibersort/workflow/iatlas_workflow/api_workflow.cwl"
//example params file
params.input_file = "syn51089849"

//get input yaml file from synapse
//downloads synapse file given Synapse ID
process SYNAPSE_GET {

    container "sagebionetworks/synapsepythonclient:v2.7.0"
    
    secret 'SYNAPSE_AUTH_TOKEN'

    input:
    val(syn_id)

    output:
    path('*.yaml')

    script:
    """    
    synapse get ${syn_id}
    shopt -s nullglob
    for f in *\\ *; do mv "\${f}" "\${f// /_}"; done
    """
}

//runs cwl workflow using url and params provided
process EXECUTE_CWL_WORKFLOW {
    container "quay.io/commonwl/cwltool:3.1.20230213100550"
    containerOptions '-v "$PWD":"$PWD" -w="$PWD"'
    shell "/usr/bin/env"

    secret "SYNAPSE_AUTH_TOKEN"

    debug true

    input:
    val cwl_file
    file cwl_input_file

    output:

    script:
    """
    cwl-runner ${cwl_file} ${cwl_input_file}
    """
}

workflow {
    SYNAPSE_GET(params.input_file)
    EXECUTE_CWL_WORKFLOW(params.cwl_file, SYNAPSE_GET.output)
}
