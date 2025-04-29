#!/bin/bash

# ============================
#  Create Azure AI Search
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

read -p "Search service name [default: $AZURE_SEARCH_NAME]: " SEARCH_NAME_INPUT
AZURE_SEARCH_NAME=${SEARCH_NAME_INPUT:-$AZURE_SEARCH_NAME}

echo " Creating Azure AI Search service: $AZURE_SEARCH_NAME"
az search service create \
  --subscription "$AZURE_SUBSCRIPTION_ID" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_SEARCH_NAME" \
  --location "$AZURE_LOCATION" \
  --sku basic

AZURE_SEARCH_KEY=$(az search admin-key show \
  --service-name "$AZURE_SEARCH_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "primaryKey" --output tsv)

echo " Azure Search ready!"
echo "AZURE_SEARCH_KEY=$AZURE_SEARCH_KEY"
