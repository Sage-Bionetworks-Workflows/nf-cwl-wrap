FROM quay.io/commonwl/cwltool:3.1.20230213100550

# Set entrypoint
ENTRYPOINT [""]

#install bash
RUN apk update
RUN apk upgrade
RUN apk add bash

#keep container running and listening for commands
#CMD ["tail", "-f", "/dev/null"]
