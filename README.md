# NF-CWL-Wrap

A Nextflow wrapper for executing CWL workflows.

## Example Usage

This repository includes a simple "Hello World" example that demonstrates how to use the wrapper. The example concatenates pairs of words from different languages.

### Prerequisites

- Docker
- Nextflow
- CWL Tool

### Running the Example

The example is configured to run out of the box. To run locally:

```bash
nextflow run main.nf -without-wave
```

This will:
1. Read the manifest file at `example/inputs/manifest.csv`
2. Process each row, which contains pairs of files
3. Use the CWL workflow at `example/workflow/hello_world.cwl`
4. Output the concatenated results

### Using Private Containers

If your CWL workflow uses a private Docker container, you'll need to provide your Docker registry credentials. You can do this in two ways:

1. Using environment variables:
```bash
export CONTAINER_REGISTRY_ACCESS_TOKEN=your_docker_token
nextflow run main.nf -without-wave --registry_username your_username
```

2. Using Nextflow secrets:
```bash
nextflow secrets set CONTAINER_REGISTRY_ACCESS_TOKEN your_docker_token
nextflow run main.nf -without-wave --registry_username your_username
```

The `--registry_username` parameter is required when using a private container. The workflow will automatically log in to Docker Hub using these credentials.

### Example Structure

- `example/inputs/`: Contains the input files and manifest
  - `manifest.csv`: Lists pairs of files to process
  - Various text files with words in different languages
- `example/workflow/`: Contains the CWL workflow and Docker configuration
  - `hello_world.cwl`: The CWL workflow definition
  - `Dockerfile`: Used to build the example container
  - `concat.sh`: The script that performs the concatenation

### Building and Pushing the Example Container

The example includes a simple container that can be built and pushed to Docker Hub:

```bash
# Build for both amd64 and arm64 platforms
docker buildx build --platform linux/amd64,linux/arm64 -t your-username/hello-world-cwl:latest --push .
```

### Configuration

The workflow is configured in `nextflow.config`. You can modify the following parameters:

- `params.manifest`: Path to the input manifest file
- `params.cwl_file`: Path to the CWL workflow file
- `params.registry_username`: Docker registry username (if needed)
- `params.registry`: Docker registry URL (defaults to docker.io)

## Introduction

`nf-cwl-wrap` is a Nextflow wrapper for CWL workflows. It uses `cwltool` to execute workflows and can be used both locally and on Seqera Platform.

## Workflow Summary

`nf-cwl-wrap` takes a `.cwl` workflow file (`cwl_file`) and a `.csv` input file (`manifest`). The `.csv` file is expected to be in the following format:

```
input_file,data_file
hello.txt,world.txt
hola.txt,mundo.txt
```

It should contain paths to `input_file`s and `data_file`s that will be processed by the CWL workflow. The manifest can contain multiple rows in this format. It will create a channel for each row and execute the CWL workflow on the files provided in parallel.

## Quick Start

1. Install [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=22.10.1`)
2. Install [Docker](https://docs.docker.com/engine/install/)
3. Download this workflow and test it with the default parameters:
```bash
nextflow run main.nf -profile local
```
4. Run your own workflows:
```bash
nextflow run main.nf -profile local --cwl_file YOUR_CWL_FILE --manifest YOUR_MANIFEST_FILE
```

5. Using a private container for your CWL workflow:

Local runs:

You will need to provide your Docker registry credentials to the workflow. Your authentication token should be set as a Nextflow secret.

```
nextflow secrets set CONTAINER_REGISTRY_ACCESS_TOKEN your_docker_token
```

Then, you must provide your Docker registry username to the workflow.

```
nextflow run main.nf -profile local --registry_username your_username
```

Seqera Platform runs:

In your Seqera Platform workspace, you will need to create a new secret with the name `CONTAINER_REGISTRY_ACCESS_TOKEN` and set it to your Docker registry authentication token.

Then, you must pass the secret to your workflow run in the "Pipeline secrets" section of the workflow run page.
