#!/bin/bash

tenantLogin(){
    az login --service-principal -u $TENANT_URL -p $TENANT_PASSWORD --tenant $TENANT_ID
}

userLogin() {
    az login -u $AZURE_USERNAME -p $AZURE_PASSWORD
}

creation(){

    echo "--- REGISTER IOT DEVICE ---"

    NAME='nuvla-'$(hostname)

    az iot hub device-identity create --device-id $NAME --hub-name $AZURE_IOT_HUB_NAME --edge-enabled

    CONNECTION_STRING=$(az iot hub device-identity show-connection-string --device-id $NAME --hub-name $AZURE_IOT_HUB_NAME | jq -r '.connectionString')
    
    az iot hub device-twin update --device-id $NAME --hub-name $AZURE_IOT_HUB_NAME
}

edgeRuntime(){

echo "--- STARTING IOT EDGE RUNTIME ---"

IP=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

echo export IOTEDGE_HOST=http://$IP:15580 >> ~/.bashrc

cat <<EOF > /etc/iotedge/config.yaml
provisioning:
  source: "manual"
  device_connection_string: "$CONNECTION_STRING"
agent:
  name: "edgeAgent"
  type: "docker"
  env: {}
  config:
    image: "mcr.microsoft.com/azureiotedge-agent:1.0"
    auth: {}
hostname: "8c7fe9bb72d3"
connect:
  management_uri: "unix:///var/run/iotedge/mgmt.sock"
  workload_uri: "unix:///var/run/iotedge/workload.sock"
listen:
  management_uri: "fd://iotedge.mgmt.socket"
  workload_uri: "fd://iotedge.socket"
homedir: "/var/lib/iotedge"
moby_runtime:
  uri: "unix:///docker/docker.sock"
EOF

cat /etc/iotedge/config.yaml

iotedged -c /etc/iotedge/config.yaml 

}   


if [ -z "$CONNECTION_STRING" ]; 
then
    echo "NO CONNECTION STRING PROVIDED. STARTING DEVICE CREATION"

    if [ -n "$AZURE_USERNAME" ] && [ -n "$AZURE_PASSWORD" ] && [ -n "$AZURE_IOT_HUB_NAME" ]
    then
        userLogin
    elif [ -n "$TENANT_URL" ] && [ -n "$TENANT_PASSWORD" ] && [ -n "$TENANT_ID" ] 
    then
        tenantLogin
    else
        echo "NO CREDENTIALS AVAILABLE. EXITING."
        exit
    fi
    creation

fi 

edgeRuntime
