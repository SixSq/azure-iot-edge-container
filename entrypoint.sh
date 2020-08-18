# Step 1: Check Env Vars


function conn_string {
    sed -i 's/"CONNECTION_STRING_REPLACE_ME"/"'"$1"'"/g' config.yaml
}

if [-z "$CONNECTION_STRING"]
then
    conn_string $CONNECTION_STRING
elif [-z "$AZURE_USERNAME"] && [-z "$AZURE_PASSWORD"] && [-z "$AZURE_IOT_HUB_NAME"]
then
    az login -u $AZURE_USERNAME -p $AZURE_PASSWORD
    CONN_STRING = $(az iot hub device-identity create --device-id $DEVICE_ID --hub-name $AZURE_IOT_HUB_NAME --edge-enabled)
    conn_string $CONN_STRING
else
    echo 'Error: Environmental Variables not set.'
fi

# Chown docker.sock
chown root:docker /docker/docker.sock

# Restart IoTEdge
sudo systemctl restart iotedge 