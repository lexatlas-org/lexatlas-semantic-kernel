#!/bin/bash

# Load environment variables from .env file
set -o allexport
source .env
set +o allexport

# Validate required environment variables
required_vars=(
  SOLUTION_NAME
  SOLUTION_LOCATION
  KEY_VAULT_NAME
  DEPLOYMENT_TYPE
  GPT_MODEL_NAME
  GPT_MODEL_VERSION
  GPT_DEPLOYMENT_CAPACITY
  EMBEDDING_MODEL
  EMBEDDING_DEPLOYMENT_CAPACITY
  MANAGED_IDENTITY_OBJECT_ID
  SUBSCRIPTION_ID
  RESOURCE_GROUP_NAME
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: $var is not set in the .env file."
    exit 1
  fi
done

# Log in to Azure (if not already logged in)
echo "Logging in to Azure..."
az account show > /dev/null 2>&1 || az login

# Set the subscription
echo "Setting subscription to $SUBSCRIPTION_ID..."
az account set --subscription "$SUBSCRIPTION_ID"

# Create the resource group if it doesn't exist
echo "Checking if resource group '$RESOURCE_GROUP_NAME' exists..."
az group show --name "$RESOURCE_GROUP_NAME" &>/dev/null

if [ $? -ne 0 ]; then
  echo "Resource group '$RESOURCE_GROUP_NAME' does not exist. Creating it..."
  az group create --name "$RESOURCE_GROUP_NAME" --location "$SOLUTION_LOCATION"
else
  echo "Resource group '$RESOURCE_GROUP_NAME' already exists."
fi

# Deploy the Bicep file
echo "Deploying main.bicep to resource group: $RESOURCE_GROUP_NAME..."
az deployment group create \
  --name "aiFoundaryDeployment" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --template-file main.bicep \
  --parameters \
    solutionName="$SOLUTION_NAME" \
    solutionLocation="$SOLUTION_LOCATION" \
    keyVaultName="$KEY_VAULT_NAME" \
    deploymentType="$DEPLOYMENT_TYPE" \
    gptModelName="$GPT_MODEL_NAME" \
    gptModelVersion="$GPT_MODEL_VERSION" \
    gptDeploymentCapacity="$GPT_DEPLOYMENT_CAPACITY" \
    embeddingModel="$EMBEDDING_MODEL" \
    embeddingDeploymentCapacity="$EMBEDDING_DEPLOYMENT_CAPACITY" \
    managedIdentityObjectId="$MANAGED_IDENTITY_OBJECT_ID"

# Check deployment status
if [ $? -eq 0 ]; then
  echo "Deployment completed successfully!"
else
  echo "Deployment failed. Check the logs above for details."
  exit 1
fi