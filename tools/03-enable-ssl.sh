#!/bin/bash

# ====================================
# Azure Static Web App - Enable SSL
# ====================================

# Load environment
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found in the current directory."
  echo " Please create a .env file with your configuration values."
  exit 1
fi

read -p "Static Web App name [default: $SWA_NAME]: " SWA_NAME_INPUT
SWA_NAME=${SWA_NAME_INPUT:-$SWA_NAME}

read -p "Resource group name [default: $AZURE_RESOURCE_GROUP]: " AZURE_RESOURCE_GROUP_INPUT
AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP_INPUT:-$AZURE_RESOURCE_GROUP}

read -p "Custom domain to enable SSL [default: $CUSTOM_DOMAIN]: " CUSTOM_DOMAIN_INPUT
CUSTOM_DOMAIN=${CUSTOM_DOMAIN_INPUT:-$CUSTOM_DOMAIN}

if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo " Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

echo " Enabling HTTPS for '$CUSTOM_DOMAIN'..."

# Enable SSL
az staticwebapp hostname enable-ssl \
  --name "$SWA_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --hostname "$CUSTOM_DOMAIN"

echo ""
echo " HTTPS enabled (or request submitted)."
echo " It may take several minutes to finalize. Check Azure Portal or CLI for certificate status."
