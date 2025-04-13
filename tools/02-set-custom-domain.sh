#!/bin/bash

# ====================================
# Azure Static Web App - Set Hostname
# ====================================

# Prompt for inputs with default values
read -p "Static Web App name [default: lexatlas-frontend]: " SWA_NAME
SWA_NAME=${SWA_NAME:-lexatlas-frontend}

read -p "Resource group name [default: lexatlas-rg]: " RG_NAME
RG_NAME=${RG_NAME:-lexatlas-rg}

read -p "Custom domain to assign [default: www.lexatlas.cloud]: " CUSTOM_DOMAIN
CUSTOM_DOMAIN=${CUSTOM_DOMAIN:-www.lexatlas.cloud}

# Validate domain format
if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo " Error: Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

echo " Associating custom domain '$CUSTOM_DOMAIN' with Static Web App '$SWA_NAME' in resource group '$RG_NAME'..."

# Set the custom domain
az staticwebapp hostname set \
  --name "$SWA_NAME" \
  --resource-group "$RG_NAME" \
  --hostname "$CUSTOM_DOMAIN"

# Get default hostname to use in DNS config
DEFAULT_HOSTNAME=$(az staticwebapp show --name "$SWA_NAME" --resource-group "$RG_NAME" --query defaultHostname -o tsv)

echo ""
echo " Hostname assignment command executed!"
echo ""
echo " Your Static Web App's default hostname is:"
echo "    $DEFAULT_HOSTNAME"
echo ""
echo " To verify your custom domain, add the following CNAME record in your DNS provider:"
echo ""
echo "    Type:   CNAME"
echo "    Name:   www"
echo "    Value:  $DEFAULT_HOSTNAME"
echo ""
echo " Azure will verify this periodically. Once verified, you can run 'enable-ssl.sh' to enable HTTPS."
