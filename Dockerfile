FROM quay.io/commonwl/cwltool:3.1.20230213100550

#install bash
RUN apk update
RUN apk upgrade
RUN apk add bash

# Set entrypoint
ENTRYPOINT [""]


#keep container running and listening for commands
#CMD ["tail", "-f", "/dev/null"]
