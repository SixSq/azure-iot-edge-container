FROM ubuntu:18.04


RUN apt update && apt install curl iproute2 gpg nano -y && \
    curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod.list && \
    cp ./microsoft-prod.list /etc/apt/sources.list.d/ && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    cp ./microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    apt-get update && \
    apt-get install moby-engine moby-cli -y && \
    apt-get install iotedge -y


EXPOSE 15580
EXPOSE 15581

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["/usr/local/bin/entrypoint.sh"]