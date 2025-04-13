#!/bin/bash

# ====================================
# Azure Static Web App - Set Hostname
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

read -p "Resource group name [default: $RG_NAME]: " RG_NAME_INPUT
RG_NAME=${RG_NAME_INPUT:-$RG_NAME}

read -p "Custom domain to assign [default: $CUSTOM_DOMAIN]: " CUSTOM_DOMAIN_INPUT
CUSTOM_DOMAIN=${CUSTOM_DOMAIN_INPUT:-$CUSTOM_DOMAIN}

if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo " Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

echo " Associating custom domain '$CUSTOM_DOMAIN' with Static Web App '$SWA_NAME'..."

# Set the custom domain
az staticwebapp hostname set \
  --name "$SWA_NAME" \
  --resource-group "$RG_NAME" \
  --hostname "$CUSTOM_DOMAIN"

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
