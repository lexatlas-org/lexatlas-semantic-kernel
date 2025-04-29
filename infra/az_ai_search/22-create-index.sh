#!/bin/bash


# fix in the indexer:
#   "fieldMappings": [
#     {
#       "sourceFieldName": "metadata_storage_path",
#       "targetFieldName": "metadata_storage_path",
#       "mappingFunction": {
#         "name": "base64Encode",
#         "parameters": null
#       }
#     }
#   ],

# # cnn to container , 
# # create los ai services (para los skills)
# # index
# # indexer 

#         # create_data_source 
#         # create_skillset 
#         # create_index 
#         # create_indexer     

# ===========================================
# 🔍 Create Search Pipeline with Interactive Prompts
# ===========================================

# Load environment from .env file
if [[ -f .env ]]; then
  source .env
else
  echo " Error: .env file not found."
  echo "Please create a .env file with the required variables."
  exit 1
fi

# Interactive prompts
read -p "Resource group name [default: $AZURE_RESOURCE_GROUP]: " RG_INPUT
AZURE_RESOURCE_GROUP=${RG_INPUT:-$AZURE_RESOURCE_GROUP}

read -p "Storage account name [default: $AZURE_STORAGE_ACCOUNT_NAME]: " STG_INPUT
AZURE_STORAGE_ACCOUNT_NAME=${STG_INPUT:-$AZURE_STORAGE_ACCOUNT_NAME}

read -p "Blob container name [default: $AZURE_STORAGE_CONTAINER]: " CONTAINER_INPUT
AZURE_STORAGE_CONTAINER=${CONTAINER_INPUT:-$AZURE_STORAGE_CONTAINER}

read -p "Search service name [default: $AZURE_SEARCH_NAME]: " SEARCH_INPUT
AZURE_SEARCH_NAME=${SEARCH_INPUT:-$AZURE_SEARCH_NAME}

read -p "Data source name [default: $AZURE_SEARCH_DATASOURCE]: " DS_INPUT
AZURE_SEARCH_DATASOURCE=${DS_INPUT:-$AZURE_SEARCH_DATASOURCE}

read -p "Skillset name [default: $AZURE_SEARCH_SKILLSET]: " SKILL_INPUT
AZURE_SEARCH_SKILLSET=${SKILL_INPUT:-$AZURE_SEARCH_SKILLSET}

read -p "Index name [default: $AZURE_SEARCH_INDEX]: " IDX_INPUT
AZURE_SEARCH_INDEX=${IDX_INPUT:-$AZURE_SEARCH_INDEX}

read -p "Indexer name [default: $AZURE_SEARCH_INDEXER]: " INDEXER_INPUT
AZURE_SEARCH_INDEXER=${INDEXER_INPUT:-$AZURE_SEARCH_INDEXER}


AZURE_SEARCH_ENDPOINT="https://${AZURE_SEARCH_NAME}.search.windows.net"
AZURE_SEARCH_KEY=$(az search admin-key show \
  --service-name "$AZURE_SEARCH_NAME" \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --query "primaryKey" -o tsv)

 export AZURE_LOCATION AZURE_RESOURCE_GROUP AZURE_SUBSCRIPTION_ID AZURE_STORAGE_ACCOUNT_NAME \
        AZURE_STORAGE_CONTAINER AZURE_STORAGE_ACCOUNT_KEY AZURE_AISERVICE_NAME AZURE_AISERVICE_KEY \
        AZURE_SEARCH_NAME AZURE_SEARCH_KEY AZURE_SEARCH_INDEX AZURE_SEARCH_DATASOURCE AZURE_SEARCH_INDEXER \
        AZURE_SEARCH_SKILLSET AZURE_SEARCH_SEMANTIC_CONFIG_NAME AZURE_OPENAI_NAME AZURE_OPENAI_DEPLOYMENT \
        AZURE_OPENAI_MODEL_NAME AZURE_OPENAI_MODEL_VERSION AZURE_OPENAI_ENDPOINT AZURE_OPENAI_KEY

echo $AZURE_SEARCH_KEY

# 01 - CREATE DATA SOURCE
# Get connection string from Azure Storage
# AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string \
#   --name "$AZURE_STORAGE_ACCOUNT_NAME" \
#   --resource-group "$AZURE_RESOURCE_GROUP" \
#   --query "connectionString" -o tsv)

# echo "Creating Data Source for AI Search..."
# az rest --method PUT --uri "https://$AZURE_SEARCH_NAME.search.windows.net/datasources/$AZURE_SEARCH_DATASOURCE?api-version=2023-11-01" \
#         --headers "Content-Type=application/json" "api-key=$AZURE_SEARCH_KEY" \
#         --body '{
#             "name": "'"$AZURE_SEARCH_DATASOURCE"'",
#             "type": "azureblob",
#             "credentials": { "connectionString": "'"$AZURE_STORAGE_CONNECTION_STRING"'" },
#             "container": { "name": "'"$AZURE_STORAGE_CONTAINER"'" }
#         }'

# echo "Data Source '$AZURE_SEARCH_DATASOURCE' successfully created."
  

# 02 - CREATE SKILLSET
envsubst  < ./schema/skillset.json > /tmp/skillset.json
# cat /tmp/skillset.json 
az rest --method POST \
    --uri "https://$AZURE_SEARCH_NAME.search.windows.net/skillsets?api-version=2023-11-01" \
    --headers "Content-Type=application/json" "api-key=$AZURE_SEARCH_KEY" \
    --body @/tmp/skillset.json
echo "Skillset '$AZURE_SEARCH_SKILLSET' successfully created."

# # 03 - CREATE INDEX
# envsubst  < ./schema/index.json > /tmp/index.json
# # cat /tmp/index.json
# az rest --method POST \
#     --uri "https://$AZURE_SEARCH_NAME.search.windows.net/indexes?api-version=2023-11-01" \
#     --headers "Content-Type=application/json" "api-key=$AZURE_SEARCH_KEY" \
#     --body @/tmp/index.json
# echo "Index '$AZURE_SEARCH_INDEX' successfully created."

# # 04 - CREATE INDEXER
# envsubst  < ./schema/indexer.json > /tmp/indexer.json
# # cat /tmp/indexer.json
# az rest --method POST \
#     --uri "https://$AZURE_SEARCH_NAME.search.windows.net/indexers?api-version=2023-11-01" \
#     --headers "Content-Type=application/json" "api-key=$AZURE_SEARCH_KEY" \
#     --body @/tmp/indexer.json
# echo "Indexer '$AZURE_SEARCH_INDEXER' successfully created."

