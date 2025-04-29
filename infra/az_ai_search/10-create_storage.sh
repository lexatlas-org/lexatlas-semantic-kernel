#!/bin/bash

# ============================
#  Create Azure Blob Storage
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

read -p "Storage account name [default: $AZURE_STORAGE_ACCOUNT_NAME]: " STG_INPUT
AZURE_STORAGE_ACCOUNT_NAME=${STG_INPUT:-$AZURE_STORAGE_ACCOUNT_NAME}

read -p "Blob container name [default: $AZURE_STORAGE_CONTAINER]: " CONTAINER_INPUT
AZURE_STORAGE_CONTAINER=${CONTAINER_INPUT:-$AZURE_STORAGE_CONTAINER}

echo " Creating Resource Group: $AZURE_RESOURCE_GROUP"
az group create --name "$AZURE_RESOURCE_GROUP" --location "$AZURE_LOCATION" --subscription "$AZURE_SUBSCRIPTION_ID"

echo " Creating Storage Account: $AZURE_STORAGE_ACCOUNT_NAME in $AZURE_LOCATION"
az storage account create \
  --subscription "$AZURE_SUBSCRIPTION_ID" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --location "$AZURE_LOCATION" \
  --sku Standard_LRS \
  --allow-blob-public-access true
  # Allow Blob anonymous access


AZURE_STORAGE_ACCOUNT_KEY=$(az storage account keys list \
  --subscription "$AZURE_SUBSCRIPTION_ID" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --query "[0].value" --output tsv)

echo " Creating blob container: $AZURE_STORAGE_CONTAINER"
az storage container create \
  --subscription "$AZURE_SUBSCRIPTION_ID" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --name "$AZURE_STORAGE_CONTAINER" \
  --account-key "$AZURE_STORAGE_ACCOUNT_KEY"  
  # --public-access off

echo " Done!"
echo "AZURE_STORAGE_ACCOUNT_KEY=$AZURE_STORAGE_ACCOUNT_KEY"
