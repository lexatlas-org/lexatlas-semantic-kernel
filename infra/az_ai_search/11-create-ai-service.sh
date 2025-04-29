#!/bin/bash

# ============================
#  Create Azure AI Services (Cognitive Services)
# ============================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

read -p "Subscription ID [default: $AZURE_SUBSCRIPTION_ID]: " SUBSCRIPTION_INPUT
AZURE_SUBSCRIPTION_ID=${SUBSCRIPTION_INPUT:-$AZURE_SUBSCRIPTION_ID}

read -p "Resource group name [default: $AZURE_RESOURCE_GROUP]: " RG_INPUT
AZURE_RESOURCE_GROUP=${RG_INPUT:-$AZURE_RESOURCE_GROUP}

read -p "Region [default: $AZURE_LOCATION]: " LOC_INPUT
AZURE_LOCATION=${LOC_INPUT:-$AZURE_LOCATION}

read -p "Cognitive Services name [default: $AZURE_AISERVICE_NAME]: " COG_INPUT
AZURE_AISERVICE_NAME=${COG_INPUT:-$AZURE_AISERVICE_NAME}

echo " Creating Azure Cognitive Services resource: $AZURE_AISERVICE_NAME in $AZURE_LOCATION"

az cognitiveservices account create \
  --subscription "$AZURE_SUBSCRIPTION_ID" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_AISERVICE_NAME" \
  --kind CognitiveServices \
  --sku S0 \
  --location "$AZURE_LOCATION" \
  --yes

AZURE_AISERVICE_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_AISERVICE_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "key1" -o tsv)

echo " Azure AI Services ready!"
echo "AZURE_AISERVICE_KEY=$AZURE_AISERVICE_KEY"
