FROM python:3.11

#Add the official Docker (apt-get) repository
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    focal stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

#install apt-get dependencies
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    git \
    gcc \
    python3 \
    libxml2-dev \
    libxslt-dev \
    libc-dev \
    nodejs \
    graphviz \
    libxml2 \
    bash \
    docker-ce 

# Clone cwltool repo - specific commit ID to control changes
RUN git clone https://github.com/common-workflow-language/cwltool.git && cd cwltool && git checkout 40c338c
WORKDIR /cwltool

# Install cwltool 
ENV BLACK_VERSION="22.0"
# The following comes directly from the original docker image (except for ENV version pinning and install location)
RUN CWLTOOL_USE_MYPYC=1 MYPYPATH=mypy-stubs pip wheel --no-binary schema-salad \
    --wheel-dir=/wheels .[deps]  # --verbose
RUN rm /wheels/schema_salad*
RUN pip install "black~=$BLACK_VERSION"
RUN SCHEMA_SALAD_USE_MYPYC=1 MYPYPATH=mypy-stubs pip wheel --no-binary schema-salad \
    $(grep schema.salad requirements.txt) "black~=$BLACK_VERSION" --wheel-dir=/wheels  # --verbose
RUN pip install --force-reinstall --no-index --no-warn-script-location \
    --root=/ /wheels/*.whl
WORKDIR /
