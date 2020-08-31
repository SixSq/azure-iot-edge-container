FROM toolboc/azure-iot-edge-device-container

ADD config.yaml /etc/iotedge/

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /var/lib/docker

EXPOSE 2375
EXPOSE 15580
EXPOSE 15581

ENTRYPOINT ["bash", "entrypoint.sh"]

CMD []
