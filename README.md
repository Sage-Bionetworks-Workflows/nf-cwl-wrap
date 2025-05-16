# NF-CWL-Wrap

A Nextflow wrapper for executing CWL workflows.

## Example Usage

This repository includes a simple "Hello World" example that demonstrates how to use the wrapper. The example concatenates pairs of words from different languages.

### Prerequisites

- Docker
- Nextflow
- CWL Tool

### Building the Example Docker Image

First, build the Docker image for the example workflow:

```bash
cd example/workflow
docker build -t hello-world-cwl:latest .
```

### Running the Example

The example is configured to run out of the box. Simply run:

```bash
nextflow run main.nf
```

This will:
1. Read the manifest file at `example/inputs/manifest.csv`
2. Process each row, which contains pairs of files to concatenate
3. Use the CWL workflow at `example/workflow/hello_world.cwl`
4. Output the concatenated results

### Example Structure

- `example/inputs/`: Contains the input files and manifest
  - `manifest.csv`: Lists pairs of files to process
  - Various text files with words in different languages
- `example/workflow/`: Contains the CWL workflow and Docker configuration
  - `hello_world.cwl`: The CWL workflow definition
  - `Dockerfile`: Defines the container for the workflow
  - `concat.py`: The Python script that performs the concatenation

### Configuration

The workflow is configured in `nextflow.config`. You can modify the following parameters:

- `params.manifest`: Path to the input manifest file
- `params.cwl_file`: Path to the CWL workflow file
- `params.registry_username`: Docker registry username (if needed)
- `params.registry`: Docker registry URL

## Introduction

`nf-cwl-wrap` is a Nextflow wrapper for CWL workflows. It uses `cwltool` to execute workflows and can be used both locally and on Nextflow Tower.

## Workflow Summary

`nf-cwl-wrap` takes a `.cwl` workflow file (`cwl_file`) and a `.csv` input file (`s3_file`). The `.csv` file is expected to be in the following format:

```
data_file,input_file
s3://iatlas-project-tower-bucket/iatlas_fpkm.tsv,s3://iatlas-project-tower-bucket/immune_subtype_clustering_input.json
```

It should contain paths to a `data_file` - the input data for the CWL workflow, and an `input_file` - a `.json` or `.yaml` file containing the required metadata for the CWL workflow run. The `s3_file` can contain multiple rows in this format. It will create a channel for each row and execute the CWL workflow on the files provided in parallel. Outputs are stored in the working directory for each process execution.

The `s3_file` format is compatible with [`nf-synstage`](https://github.com/Sage-Bionetworks-Workflows/nf-synstage) so that users can first stage their `data_file`'s and `input_file`'s in S3 buckets ahead of Nextflow Tower runs with this repository.
 
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

