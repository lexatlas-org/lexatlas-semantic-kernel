#!/bin/bash

# ===========================
# Azure Static Web App Script
# ===========================

# Load environment
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found in the current directory."
  echo " Please create a .env file with your configuration values."
  exit 1
fi

# Supported regions for Microsoft.Web/staticSites
VALID_REGIONS=("westus2" "centralus" "eastus2" "westeurope" "eastasia")

read -p "Static Web App name [default: $SWA_NAME]: " SWA_NAME_INPUT
SWA_NAME=${SWA_NAME_INPUT:-$SWA_NAME}

read -p "Resource group name [default: $RG_NAME]: " RG_NAME_INPUT
RG_NAME=${RG_NAME_INPUT:-$RG_NAME}

read -p "Azure region [default: $LOCATION]: " LOCATION_INPUT
LOCATION=${LOCATION_INPUT:-$LOCATION}
LOCATION_LOWER=$(echo "$LOCATION" | tr '[:upper:]' '[:lower:]')

if [[ ! " ${VALID_REGIONS[*]} " =~ " ${LOCATION_LOWER} " ]]; then
  echo " Error: '$LOCATION' is not a valid region for Azure Static Web Apps."
  echo " Valid regions are: ${VALID_REGIONS[*]}"
  exit 1
fi

read -p "GitHub repo URL [default: $GITHUB_REPO]: " GITHUB_REPO_INPUT
GITHUB_REPO=${GITHUB_REPO_INPUT:-$GITHUB_REPO}

read -p "Branch name to deploy [default: $BRANCH]: " BRANCH_INPUT
BRANCH=${BRANCH_INPUT:-$BRANCH}

read -p "GitHub token (leave empty to use browser login): " GITHUB_TOKEN

echo " Creating Resource Group: $RG_NAME"
az group create --name "$RG_NAME" --location "$LOCATION_LOWER"

# Execute the az staticwebapp create command
echo " Running deployment command..."
if [[ -n "$GITHUB_TOKEN" ]]; then
  echo " Using GitHub token for authentication"
  az staticwebapp create \
    --name "$SWA_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION_LOWER" \
    --source "$GITHUB_REPO" \
    --branch "$BRANCH" \
    --app-location "/" \
    --output-location "" \
    --token "$GITHUB_TOKEN"
else
  echo " Using browser GitHub login"
  az staticwebapp create \
    --name "$SWA_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION_LOWER" \
    --source "$GITHUB_REPO" \
    --branch "$BRANCH" \
    --app-location "/" \
    --output-location "" \
    --login-with-github
fi

echo " Deployment triggered. Check your GitHub Actions for progress."
