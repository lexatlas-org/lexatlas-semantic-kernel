@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the AI Hub will be deployed')
param location string

@description('Resource ID of the Key Vault to be used by the AI Hub')
param keyVaultId string

@description('Resource ID of the Storage Account to be used by the AI Hub')
param storageAccountId string

@description('Resource ID of the Container Registry to be used by the AI Hub')
param containerRegistryId string

@description('Resource ID of the Application Insights instance to be used by the AI Hub')
param appInsightsId string

@description('Endpoint URL of the Azure OpenAI resource')
param openAiEndpoint string

@description('API Key for the Azure OpenAI resource')
param openAiKey string

@description('Resource ID of the Azure OpenAI resource')
param openAiId string

@description('Endpoint URL of the Azure Cognitive Search resource')
param aiSearchEndpoint string

@description('Admin key for the Azure Cognitive Search resource')
param aiSearchKey string

@description('Resource ID of the Azure Cognitive Search resource')
param aiSearchId string

var aiHubName = 'hub-${solutionName}'

// AI Hub Resource
resource aiHub 'Microsoft.MachineLearningServices/workspaces@2023-08-01-preview' = {
  name: aiHubName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'hub'
  properties: {
    friendlyName: aiHubName
    description: 'AI Hub'
    // keyVault: keyVaultId
    storageAccount: storageAccountId
    applicationInsights: appInsightsId
    containerRegistry: containerRegistryId
  }

  // OpenAI Connection  AQUIIII EL PROBLEMA
  // resource openAiConn 'connections@2024-07-01-preview' = {
  //   name: '${aiHubName}-connection-openai'
  //   properties: {
  //     category: 'AIServices'
  //     target: openAiEndpoint
  //     authType: 'ApiKey'
  //     isSharedToAll: true
  //     credentials: { key: openAiKey }
  //     metadata: {
  //       ApiType: 'Azure'
  //       ResourceId: openAiId
  //     }
  //   }
  // }

  // Cognitive Search Connection
  resource searchConn 'connections@2024-07-01-preview' = {
    name: '${aiHubName}-connection-search'
    properties: {
      category: 'CognitiveSearch'
      target: aiSearchEndpoint
      authType: 'ApiKey'
      isSharedToAll: true
      credentials: { key: aiSearchKey }
      metadata: {
        ApiType: 'Azure'
        ResourceId: aiSearchId
        ApiVersion: '2024-05-01-preview'
        DeploymentApiVersion: '2023-11-01'
      }
    }
  }
}

@description('Resource ID of the deployed AI Hub')
output id string = aiHub.id

@description('Name of the deployed AI Hub')
output name string = aiHub.name
