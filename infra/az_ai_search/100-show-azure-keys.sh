#!/bin/bash

# ============================
# Generate Core Azure ENV Vars for Agentic RAG
# ============================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo "❌ Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

# Check required base vars
required_vars=(
  AZURE_RESOURCE_GROUP
  AZURE_OPENAI_NAME
  AZURE_OPENAI_DEPLOYMENT
  AZURE_SEARCH_NAME
  AZURE_SEARCH_INDEX
  AZURE_SEARCH_SEMANTIC_CONFIG_NAME
  AZURE_STORAGE_ACCOUNT_NAME
  AZURE_STORAGE_CONTAINER
  AZURE_AISERVICE_NAME
)

for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "❗ Missing environment variable: $var"
    exit 1
  fi
done

# === 1. Azure OpenAI ===
AZURE_OPENAI_ENDPOINT=$(az cognitiveservices account show \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "properties.endpoint" -o tsv)/openai/deployments/$AZURE_OPENAI_DEPLOYMENT

AZURE_OPENAI_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_OPENAI_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "key1" -o tsv)

# === 2. Azure Cognitive Search ===
AZURE_SEARCH_ENDPOINT="https://${AZURE_SEARCH_NAME}.search.windows.net"
AZURE_SEARCH_KEY=$(az search admin-key show \
  --service-name "$AZURE_SEARCH_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "primaryKey" -o tsv)

# === 3. Azure Blob Storage ===
AZURE_STORAGE_ACCOUNT_KEY=$(az storage account keys list \
  --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "[0].value" -o tsv)

# === 4. Azure AI Service (for Skillsets) ===
AZURE_AISERVICE_KEY=$(az cognitiveservices account keys list \
  --name "$AZURE_AISERVICE_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "key1" -o tsv)


# === Output as .env format ===
echo ""
echo " Generated .env Variables:"
echo "----------------------------"
cat <<EOF
AZURE_OPENAI_KEY=$AZURE_OPENAI_KEY
AZURE_OPENAI_ENDPOINT=$AZURE_OPENAI_ENDPOINT
AZURE_OPENAI_DEPLOYMENT=$AZURE_OPENAI_DEPLOYMENT

AZURE_SEARCH_ENDPOINT=$AZURE_SEARCH_ENDPOINT
AZURE_SEARCH_INDEX=$AZURE_SEARCH_INDEX
AZURE_SEARCH_KEY=$AZURE_SEARCH_KEY
AZURE_SEARCH_SEMANTIC_CONFIG_NAME=$AZURE_SEARCH_SEMANTIC_CONFIG_NAME

AZURE_STORAGE_ACCOUNT_NAME=$AZURE_STORAGE_ACCOUNT_NAME
AZURE_STORAGE_ACCOUNT_KEY=$AZURE_STORAGE_ACCOUNT_KEY
AZURE_STORAGE_CONTAINER=$AZURE_STORAGE_CONTAINER

AZURE_AISERVICE_NAME=$AZURE_AISERVICE_NAME
AZURE_AISERVICE_KEY=$AZURE_AISERVICE_KEY
EOF
