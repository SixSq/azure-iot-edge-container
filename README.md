# azure-iot-edge-container
Containerized Azure IoT Edge components, for automated deployment and integration with Nuvla


# Launch the container

```bash
docker run -d --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -v /var/run/docker.sock:/docker/docker.sock \
  -e CONNECTION_STRING=$azure_edge_device_connection_string \
  -e AZURE_USERNAME=$username \
  -e AZURE_PASSWORD=$password \
  -e AZURE_IOT_HUB_NAME=$iot_hub \ 
  jrei/systemd-ubuntu:18.04
```


