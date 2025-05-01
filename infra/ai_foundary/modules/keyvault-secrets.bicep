@description('Name of the Key Vault where secrets will be stored')
param keyVaultName string

@description('Azure OpenAI endpoint URL')
param aiEndpoint string

@description('Azure OpenAI API Key')
param aiKey string

@description('Name of the GPT model to deploy')
param gptModelName string

@description('Version of the GPT model API to use')
param gptModelVersion string

@description('Admin key for the Azure Cognitive Search resource')
param aiSearchKey string

@description('Endpoint URL of the Azure Cognitive Search resource')
param aiSearchEndpoint string

@description('Name of the Azure Cognitive Search resource')
param aiSearchName string

@description('Connection string for the AI Project')
param aiProjectConnStr string

@description('Azure subscription ID')
param subscriptionId string

@description('Name of the Azure resource group')
param resourceGroupName string

@description('Azure tenant ID')
param tenantId string

@description('Azure region where the resources are deployed')
param solutionLocation string = resourceGroup().location

// Reference to the existing Key Vault
resource kv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

// Secrets to be added to the Key Vault
var secrets = [
  { name: 'AZURE-OPENAI-ENDPOINT', value: aiEndpoint }
  { name: 'AZURE-OPENAI-KEY', value: aiKey }
  { name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL', value: gptModelName }
  { name: 'AZURE-OPENAI-PREVIEW-API-VERSION', value: gptModelVersion }
  { name: 'AZURE-SEARCH-KEY', value: aiSearchKey }
  { name: 'AZURE-SEARCH-ENDPOINT', value: aiSearchEndpoint }
  { name: 'AZURE-SEARCH-SERVICE', value: aiSearchName }
  { name: 'AZURE-AI-PROJECT-CONN-STRING', value: aiProjectConnStr }
  { name: 'AZURE-SUBSCRIPTION-ID', value: subscriptionId }
  { name: 'AZURE-RESOURCE-GROUP', value: resourceGroupName }
  { name: 'TENANT-ID', value: tenantId }
  { name: 'AZURE-LOCATION', value: solutionLocation }
  { name: 'AZURE-SEARCH-INDEX', value: 'pdf_index' }
]

// Add secrets to the Key Vault
resource secretsOut 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = [for s in secrets: {
  parent: kv
  name: s.name
  properties: {
    value: s.value
  }
}]

// @description('List of secrets added to the Key Vault')
// output secrets array = [for s in secretsOut: s.name]
