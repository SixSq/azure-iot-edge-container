# azure-iot-edge-container

Containerized Azure IoT Edge components, for automated deployment and integration with Nuvla


## Folder Structure

There are 2 different solutions:
- IoTEdgeDev Solution
- Entrypoint Solution

### IoTEdgeDev Solution

IoTEdgeDev is a tool to create Docker containers that deploy Azure IoT compatible code.

With this tool we are able to create a copy of an Azure Environment on a Docker container.

#### Problems

With this solution there are a couple of problems that invlidate its use.

First, this tool doesn't deploy the IoT Edge Agent, which is needed to receive Azure deployments, and send some 
statistics to the Azure IoT Hub

And second, the deployment manifest needs to be inside of the container on time of deployment, there is a need to 
add on deployment some folders. 

This is yet to be tested, but the behaviour is as described:
When the container starts, the IoTEdgeDev tool will create a new project. Then, it will build the project, in which need to have
the deployment manifest to be used. This means that it will build the container used on its deployments.
Finally, the IoTEdgeDev tool will start the containers, specifiying the deployment manifest to be used. 

#### Solutions

There is a posibility that on deployment of the container, we are able to specify a deployment manifest, and then after the creation of
the project, we place that manifest on the correct folder.
This would work, provided that the manifest is correct.

One problem with this solution is that we sidestep completly the Azure platform. If we are deploying Azure IoT modules from Nuvla, why do we 
need Azure? Why don't we just use Docker?

Also, continues to have the same problem as before, as the edge device is not registered on Azure.

### Entrypoint Solution

In this solution, the container is build using the same process as the installation process that is used directly on a edge device.

So, every step of the Docker file is directly associated to the process described on the [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux)

#### Problems

There are also two problems with this solution.

First, the Dockerfile specified on [Microsoft's Repo](https://github.com/Azure/iotedgedev/blob/master/docker/runtime/Dockerfile) is depreciated, as the instalation links are not
available.

And second, a problem that seems to persist through several different platforms (ARM, AMD, x86) is that the IoT Edge Agent is looking for a specific socket (mgmt.sock), that is not
available. 
On Github, older issues from around 2018 with the same problem say that the problem was solved. But the current version keeps having these problems.
This was due to an upgrade of Docker that didn't permit the use of `host.docker.internal` as the container device hostname.

To combat this, on the described issues there is a entrypoint script, that would fix this. But to date this script hasn't worked, as it seem to be a solution designed for Windows devices.
