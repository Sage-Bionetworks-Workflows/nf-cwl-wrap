FROM python:3.11

#install apt-get dependencies
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y git gcc python3 libxml2-dev libxslt-dev libc-dev
RUN apt install -y nodejs
RUN apt-get install -y graphviz libxml2
RUN apt-get install -y bash

#Add the official Docker (apt-get) repository
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    focal stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker - not sure why it won't work unless you update apt-get again
RUN apt-get update -y 
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Clone cwltool repo - specific commit ID to control changes
RUN git clone https://github.com/common-workflow-language/cwltool.git
WORKDIR /cwltool
RUN git checkout 40c338c

# Install cwltool
# The following comes directly form the original docker image
RUN CWLTOOL_USE_MYPYC=1 MYPYPATH=mypy-stubs pip wheel --no-binary schema-salad \
    --wheel-dir=/wheels .[deps]  # --verbose
RUN rm /wheels/schema_salad*
RUN pip install "black~=22.0"
RUN SCHEMA_SALAD_USE_MYPYC=1 MYPYPATH=mypy-stubs pip wheel --no-binary schema-salad \
    $(grep schema.salad requirements.txt) "black~=22.0" --wheel-dir=/wheels  # --verbose
RUN pip install --force-reinstall --no-index --no-warn-script-location \
    --root=/ /wheels/*.whl
WORKDIR /
