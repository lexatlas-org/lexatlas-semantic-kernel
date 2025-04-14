#!/bin/bash

# ==========================================
# Azure Static Web App - Set Custom Domain
# ==========================================

# Load environment
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found in the current directory."
  echo " Please create a .env file with your configuration values."
  exit 1
fi

# Prompt for values with .env defaults
read -p "Static Web App name [default: $SWA_NAME]: " SWA_NAME_INPUT
SWA_NAME=${SWA_NAME_INPUT:-$SWA_NAME}

read -p "Resource group name [default: $AZURE_RESOURCE_GROUP]: " AZURE_RESOURCE_GROUP_INPUT
AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP_INPUT:-$AZURE_RESOURCE_GROUP}

read -p "Custom domain to assign [default: $CUSTOM_DOMAIN]: " CUSTOM_DOMAIN_INPUT
CUSTOM_DOMAIN=${CUSTOM_DOMAIN_INPUT:-$CUSTOM_DOMAIN}

# Validate domain
if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo " Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

# Retrieve static web app default hostname for DNS setup
DEFAULT_HOSTNAME=$(az staticwebapp show \
  --name "$SWA_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query defaultHostname -o tsv)

echo ""
echo " BEFORE proceeding, please create the following CNAME record in your DNS provider:"
echo ""
echo "    Type:   CNAME"
echo "    Name:   www"
echo "    Value:  $DEFAULT_HOSTNAME"
echo ""
echo " This must be done before attempting to set the custom domain in Azure."
echo " It may take a few minutes for DNS propagation."

# Confirm DNS has been configured
read -p " Have you created the CNAME record above and waited for DNS to propagate? (y/N): " CONFIRM_DNS
if [[ ! "$CONFIRM_DNS" =~ ^[Yy]$ ]]; then
  echo ""
  echo " Please complete the DNS setup first and rerun this script afterward."
  exit 0
fi

echo ""
echo " Associating custom domain '$CUSTOM_DOMAIN' with Static Web App '$SWA_NAME'..."

# Now that DNS is ready, set the hostname
az staticwebapp hostname set \
  --name "$SWA_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --hostname "$CUSTOM_DOMAIN"

echo ""
echo " Domain successfully assigned!"
