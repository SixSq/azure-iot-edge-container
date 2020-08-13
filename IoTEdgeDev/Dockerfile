FROM microsoft/iotedgedev

RUN iotedgedev new nuvla-demo

# WORKDIR nuvla-demo

# COPY env /home/iotedge/nuvla-demo/.env
# RUN sudo chmod u+x /home/iotedge/nuvla-demo/.env

# COPY config/ /home/iotedge/nuvla-demo/config

# COPY modules/ /home/iotedge/nuvla-demo/modules

# COPY entry.sh /home/iotedge/nuvla-demo

COPY entry.sh /usr/local/bin/entry.sh
RUN sudo chmod +x /usr/local/bin/entry.sh

CMD ["/usr/local/bin/entry.sh"]