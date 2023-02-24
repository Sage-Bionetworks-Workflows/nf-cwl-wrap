# nf-cwl-wrap

## Introduction

`nf-cwl-wrap` is a Nextflow wrapper for CWL workflows. Currently, it only supports executing CWL workflows on a local machine using `cwltool` in a single process workflow. Eventually, it will be fully supported for Nextflow Tower runs. 

## Workflow Summary

`nf-cwl-wrap` takes a CWL workflow (either local file or raw GitHub user content URL) and an input file (either in YAML or JSON format) as inputs. It then passes these two parameters to a single Nextflow process which executes the CWL workflow using `cwltool`. Any ouputs from the workflow are stored in the `work/` directory. An example input file for the EPIC CWL workflow found [here](https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/develop/EPIC/workflow/steps/epic/epic.cwl) can be found in the `example_inputs/` directory of this repository.

## Quick Start

1. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=22.10.1`)
2. Install [Docker](https://docs.docker.com/engine/install/)
3. Download this workflow and test it with the default parameters using:
```
nextflow run main.nf
```
4. Run your own workflows:
```
nextflow run main.nf --cwl_file YOUR_CWL_FILE --input_file YOUR_INPUT_FILE
```

