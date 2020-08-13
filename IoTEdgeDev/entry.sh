#!/bin/bash
az login --allow-no-subscriptions

cd nuvla-demo

sudo iotedgedev iothub setup --credentials $USERNAME $PASSWORD --subscription $THE_SUBSCRIPTION_ID --resource-group-location $RG_LOCATION --resource-group-name $RG_NAME --iothub-sku $IOT_SKU --iothub-name $IOT_NAME  --edge-device-id $EDGE_DEVICE_NAME --update-dotenv

sudo iotedgedev build 

sudo iotedgedev start --setup --file config/deployment.amd64.json

bash
