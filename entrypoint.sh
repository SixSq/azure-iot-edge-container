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
    
    echo $CONNECTION_STRING

   az iot hub device-twin update --device-id $NAME --hub-name $AZURE_IOT_HUB_NAME
}

edgeRuntime(){

echo "--- STARTING IOT EDGE RUNTIME ---"

sed -i 's|"<ADD DEVICE CONNECTION STRING HERE>"|"'"$CONNECTION_STRING"'"|' /etc/iotedge/config.yaml
cat /etc/iotedge/config.yaml
systemctl restart iotedge

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
