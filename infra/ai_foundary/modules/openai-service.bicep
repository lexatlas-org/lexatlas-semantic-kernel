@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the Azure OpenAI resource will be deployed')
param location string

@description('SKU name for the Azure OpenAI resource (e.g., S0)')
param skuName string = 'S0'

var name = 'openai-${solutionName}'

// Azure OpenAI Resource
resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  kind: 'OpenAI'
  sku: { name: skuName }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

@description('Resource ID of the deployed Azure OpenAI resource')
output id string = openai.id

@description('Name of the deployed Azure OpenAI resource')
output name string = openai.name

@description('Endpoint URL of the deployed Azure OpenAI resource')
output endpoint string = openai.properties.endpoint

@description('Primary API key for the deployed Azure OpenAI resource')
output key string = listKeys(openai.id, '2023-05-01').key1
