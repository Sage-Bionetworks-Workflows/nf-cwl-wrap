FROM quay.io/commonwl/cwltool:3.1.20230213100550

# Set entrypoint
ENTRYPOINT [""]

# Mount directories
VOLUME /var/run/docker.sock:/var/run/docker.sock
VOLUME /tmp:/tmp

#install bash and curl
RUN apk update
RUN apk upgrade
RUN apk add bash

#keep contianer running and listening for commands
CMD ["tail", "-f", "/dev/null"]
