# azure-iot-edge-container
Containerized Azure IoT Edge components, for automated deployment and integration with Nuvla


# Test the containers


## Testing the Runtime Container 

To test the Azure IoT Edge Runtime container, first build the container:

```bash
docker build -t azure-iot-edge-container -f Dockerfile .
```

and then run the container with:

```bash
docker run -d --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  --network host \
  --name azure-runtime
  azure-iot-edge-container
```

Then you can introduce the commands with:

```bash

docker exec azure-runtime <command>
```

## Testing Both Containers, and the Entrypoint script

If you want to test the full workflow, please run the docker-compose file.
To do so build both containers:

```bash
docker build -t azure-iot-edge-container -f Dockerfile .
```

```bash
docker build -t azure-sidecar -f Dockerfile.sidecar .
```

And test them with the compose following compose file:

```yaml
version: '3.6'
services:

  azure-iot-edge:
    image: 'franciscomendonca/azure-runtime:1.0'
    container_name: 'azure-iot-edge'
    network_mode: 'host'
    privileged: true
    volumes: 
      - '/sys/fs/cgroup:/sys/fs/cgroup:ro'


  sidecar:
    image: franciscomendonca/azure-sidecar:1.0
    container_name: 'azure-sidecar'
    network_mode: 'host'
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
    environment:
      - TENANT_URL=...
      - TENANT_PASSWORD=...
      - TENANT_ID=...
      - AZURE_IOT_HUB_NAME=...

```

### Variables

There are 3 modes for this entryscript.

The first is the manual mode. If you want to create manually the edge device in the Azure IoT Hub,
then you can use the environmenta variable `CONNECTION_STRING` to pass the connection string that was
created.

The second is for Azure accounts that don't have 2-factor authentication. In this case you can use
`AZURE_USERNAME` and `AZURE_PASSWORD`. These will be used to login and create the device.

And the third is for accounts that have more security, or if you don't which to use your own credentials to 
login. First, create a Tenant Account in the Azure Cloud Terminal using the following command:

```bash
az ad sp create-for-rbac --name <name-for-tenant-account> 
```

This will create a tenant account. The output should be something like this:

```json
{
"appId": "app-id",
"displayName": "display-name",
"name": "http://name-for-tenant-account",
"password": "Password",
"tenant": "tenant-id"
}
```

In this case we will use `TENANT_URL`, which is the name field from the output, `TENANT_PASSWORD`, `TENANT_ID`, which is the tenant field from the output.

Afterwards, do:

```bash
docker-compose up
```


# Troubleshoot

Several problems occured when developing this project:

- Azure CLI executables not build for ARM64 devices (no RPi 4)
- Need to use Systemd to restart IoTEdge in order to use Docker and IoT Edge sockets
- Need to use a second container to restart the IoTEdge service
- Azure containers are isolated (Docker in Docker)
