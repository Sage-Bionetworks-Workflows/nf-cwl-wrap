#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

baseCommand: ["sh", "-c", "cat $1 && echo && cat $2"]

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1
  data_file:
    type: File
    inputBinding:
      position: 2

outputs:
  result:
    type: stdout

requirements:
  DockerRequirement:
    dockerPull: bwmac2/hello-world-cwl:latest
