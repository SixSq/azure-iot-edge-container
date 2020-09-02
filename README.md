# azure-iot-edge-container
Containerized Azure IoT Edge components, for automated deployment and integration with Nuvla


# Launch the container

```bash
docker run -d --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -e CONNECTION_STRING=$azure_edge_device_connection_string \
  -e AZURE_USERNAME=$username \
  -e AZURE_PASSWORD=$password \
  -e AZURE_IOT_HUB_NAME=$iot_hub \ 
  --network host \
  jrei/systemd-ubuntu:18.04
```

# Troubleshoot

Several problems occured when developing this project:

- Azure CLI executables not build for ARM64 devices (no RPi 4)
- Need to use Systemd to restart IoTEdge in order to use Docker and IoT Edge sockets
- 
