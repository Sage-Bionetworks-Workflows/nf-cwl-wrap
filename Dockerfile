FROM quay.io/commonwl/cwltool:3.1.20230213100550

# Set entrypoint
ENTRYPOINT [""]

# Mount directories
VOLUME /var/run/docker.sock:/var/run/docker.sock
VOLUME /tmp:/tmp
