#!/bin/bash

# ===========================
# Azure Static Web App Script
# ===========================

# Supported regions for Microsoft.Web/staticSites
VALID_REGIONS=("westus2" "centralus" "eastus2" "westeurope" "eastasia")

# Prompt for inputs or use default values
read -p "Static Web App name [default: lexatlas-frontend]: " SWA_NAME
SWA_NAME=${SWA_NAME:-lexatlas-frontend}

read -p "Resource group name [default: lexatlas-rg]: " RG_NAME
RG_NAME=${RG_NAME:-lexatlas-rg}

read -p "Azure region [default: eastus2]: " LOCATION
LOCATION=${LOCATION:-eastus2}
LOCATION_LOWER=$(echo "$LOCATION" | tr '[:upper:]' '[:lower:]')

# Validate location
if [[ ! " ${VALID_REGIONS[*]} " =~ " ${LOCATION_LOWER} " ]]; then
  echo " Error: '$LOCATION' is not a valid region for Azure Static Web Apps."
  echo " Valid regions are: ${VALID_REGIONS[*]}"
  exit 1
fi

read -p "GitHub repo URL [default: https://github.com/lexatlas-org/lexatlas-frontend]: " GITHUB_REPO
GITHUB_REPO=${GITHUB_REPO:-https://github.com/lexatlas-org/lexatlas-frontend}

read -p "Branch name to deploy [default: main]: " BRANCH
BRANCH=${BRANCH:-main}

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
