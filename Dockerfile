FROM jrei/systemd-ubuntu:18.04

RUN apt update && apt install -y curl lsb-release gnupg

RUN curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > /etc/apt/sources.list.d/microsoft-prod.list

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
          tee /etc/apt/sources.list.d/azure-cli.list

RUN apt update && apt install -y moby-engine && \
      apt install -y iotedge azure-cli && \
      systemctl enable iotedge && \
      apt autoclean && rm -rf /var/lib/apt/lists/*

#ADD config.yaml /etc/iotedge/
