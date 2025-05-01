// main.bicep
@description('Name prefix of the solution')
param solutionName string

@description('Azure region for the solution deployment')
param solutionLocation string

@description('Name of the existing Key Vault')
param keyVaultName string

@description('Deployment type for OpenAI (e.g., Standard)')
param deploymentType string

@description('Name of the GPT model to deploy (e.g., gpt-4)')
param gptModelName string

@description('Version of the GPT model to deploy')
param gptModelVersion string

@description('Deployment capacity for the GPT model')
@minValue(1)
@maxValue(100)
param gptDeploymentCapacity int

@description('Name of the embedding model to deploy (e.g., text-embedding-ada-002)')
param embeddingModel string

@description('Deployment capacity for the embedding model')
@minValue(1)
@maxValue(100)
param embeddingDeploymentCapacity int

@description('Object ID of the managed identity for role assignments')
param managedIdentityObjectId string

var location = solutionLocation

// print all variables
output location string = location
output solutionName string = solutionName
output keyVaultName string = keyVaultName
output deploymentType string = deploymentType   
output gptModelName string = gptModelName
output gptModelVersion string = gptModelVersion
output gptDeploymentCapacity int = gptDeploymentCapacity
output embeddingModel string = embeddingModel
output embeddingDeploymentCapacity int = embeddingDeploymentCapacity
output managedIdentityObjectId string = managedIdentityObjectId



// // Reusable Names
// var aiSearchName = 'srch-${solutionName}'
// var aiHubName = 'hub-${solutionName}'
// var aiProjectName = 'proj-${solutionName}'

// -------------------------------------------------------
// Key Vault Reference
// resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
//   name: keyVaultName
// }
module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

// -------------------------------------------------------
// Log Analytics Workspace
module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'logAnalytics'
  params: {
    solutionName: solutionName
    location: location
  }
}

// Application Insights
module appInsights 'modules/app-insights.bicep' = {
  name: 'appInsights'
  // dependsOn: [logAnalytics]
  params: {
    solutionName: solutionName
    location: location
    logAnalyticsId: logAnalytics.outputs.id
  }
}

// Azure Container Registry
module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistry'
  params: {
    solutionName: solutionName
    location: location
  }
}

// Azure Storage
module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: {
    solutionName: solutionName
    location: location
  }
}

// Azure Cognitive Services - OpenAI
module openAI 'modules/openai-service.bicep' = {
  name: 'openAI'
  params: {
    solutionName: solutionName
    location: location
  }
}

// OpenAI Model Deployments
module openAIDeployments 'modules/openai-deployments.bicep' = {
  name: 'openAIDeployments'
  // dependsOn: [openAI]
  params: {
    deploymentType: deploymentType
    gptModelName: gptModelName
    gptDeploymentCapacity: gptDeploymentCapacity
    embeddingModel: embeddingModel
    embeddingDeploymentCapacity: embeddingDeploymentCapacity
    // openAiResourceId: openAI.outputs.id
    openAiResourceName: openAI.outputs.name
  }
}

// Azure AI Search
module aiSearch 'modules/search.bicep' = {
  name: 'aiSearch'
  params: {
    solutionName: solutionName
    location: location
  }
}

// // Role Assignment
// module rbac 'modules/rbac.bicep' = {
//   name: 'rbacAssignment'
//   params: {
//     principalId: managedIdentityObjectId
//     scope: subscription().id
//     roleDefinitionId: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor
//   }
// }

// AI Hub
module aiHub 'modules/ai-hub.bicep' = {
  name: 'aiHub'
  // dependsOn: [storage, containerRegistry, appInsights, openAI, aiSearch]
  params: {
    solutionName: solutionName
    location: location
    keyVaultId: keyVault.outputs.keyVaultId
    storageAccountId: storage.outputs.id
    containerRegistryId: containerRegistry.outputs.id
    appInsightsId: appInsights.outputs.id
    openAiEndpoint: openAI.outputs.endpoint
    openAiKey: openAI.outputs.key
    openAiId: openAI.outputs.id
    aiSearchEndpoint: aiSearch.outputs.endpoint
    aiSearchKey: aiSearch.outputs.adminKey
    aiSearchId: aiSearch.outputs.id
  }
}

// AI Project
module aiProject 'modules/ai-project.bicep' = {
  name: 'aiProject'
  // dependsOn: [aiHub]
  params: {
    solutionName: solutionName
    location: location
    aiHubId: aiHub.outputs.id
  }
}

// Secrets Module
module secrets 'modules/keyvault-secrets.bicep' = {
  name: 'kvSecrets'
  // dependsOn: [aiProject]
  params: {
    keyVaultName: keyVaultName
    aiEndpoint: openAI.outputs.endpoint
    aiKey: openAI.outputs.key
    gptModelName: gptModelName
    gptModelVersion: gptModelVersion
    aiSearchKey: aiSearch.outputs.adminKey
    aiSearchEndpoint: aiSearch.outputs.endpoint
    aiSearchName: aiSearch.outputs.name
    aiProjectConnStr: '${split(aiProject.outputs.discoveryUrl, '/')[2]};${subscription().subscriptionId};${resourceGroup().name};${aiProject.outputs.name}'
    subscriptionId: subscription().subscriptionId
    resourceGroupName: resourceGroup().name
    tenantId: subscription().tenantId
  }
}

// Outputs
output aiHubId string = aiHub.outputs.id
output aiProjectId string = aiProject.outputs.id
output openAiEndpoint string = openAI.outputs.endpoint
output aiSearchEndpoint string = aiSearch.outputs.endpoint
