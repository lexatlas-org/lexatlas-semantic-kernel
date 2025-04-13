#!/bin/bash

# ====================================
# Azure Static Web App - Enable SSL
# ====================================

# Prompt for inputs with default values
read -p "Static Web App name [default: lexatlas-frontend]: " SWA_NAME
SWA_NAME=${SWA_NAME:-lexatlas-frontend}

read -p "Resource group name [default: lexatlas-rg]: " RG_NAME
RG_NAME=${RG_NAME:-lexatlas-rg}

read -p "Custom domain to enable SSL [default: www.lexatlas.cloud]: " CUSTOM_DOMAIN
CUSTOM_DOMAIN=${CUSTOM_DOMAIN:-www.lexatlas.cloud}

# Validate domain format
if [[ ! "$CUSTOM_DOMAIN" =~ ^[a-zA-Z0-9.-]+$ ]]; then
  echo " Error: Invalid domain format: $CUSTOM_DOMAIN"
  exit 1
fi

echo "🔐 Enabling HTTPS for '$CUSTOM_DOMAIN' on Static Web App '$SWA_NAME'..."

# Enable SSL
az staticwebapp hostname enable-ssl \
  --name "$SWA_NAME" \
  --resource-group "$RG_NAME" \
  --hostname "$CUSTOM_DOMAIN"

echo ""
echo " HTTPS enabled (or request submitted)."
echo " It may take several minutes to finalize. Check Azure Portal or CLI for certificate status."
