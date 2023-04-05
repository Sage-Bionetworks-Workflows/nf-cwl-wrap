FROM quay.io/commonwl/cwltool:3.1.20230213100550

# Set entrypoint
ENTRYPOINT [""]

# Mount directories
VOLUME /var/run/docker.sock:/var/run/docker.sock
VOLUME /tmp:/tmp

#install bash
RUN apk update
RUN apk upgrade
RUN apk add bash

CMD ["tail", "-f", "/dev/null"]
