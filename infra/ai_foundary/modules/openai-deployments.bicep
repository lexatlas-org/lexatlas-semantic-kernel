@description('Name of the GPT model to deploy (e.g., gpt-4)')
param gptModelName string

@description('Deployment type for the GPT model (e.g., Standard)')
param deploymentType string

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

@description('Name of the existing Azure OpenAI resource')
param openAiResourceName string

// Reference to the existing OpenAI resource in current resource group scope
resource openai 'Microsoft.CognitiveServices/accounts@2021-10-01' existing = {
  name: openAiResourceName
}

// Define the model deployments
var deployments = [
  {
    name: '${gptModelName}-deployment'
    model: gptModelName
    sku: {
      name: deploymentType
      capacity: gptDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: '${embeddingModel}-deployment'
    model: embeddingModel
    sku: {
      name: 'Standard'
      capacity: embeddingDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
]

@batchSize(1)
resource modelDeployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [for d in deployments: {
  parent: openai
  name: d.name
  properties: {
    model: {
      format: 'OpenAI'
      name: d.model
    }
    raiPolicyName: d.raiPolicyName
  }
  sku: {
    name: d.sku.name
    capacity: d.sku.capacity
  }
}]

// // Outputs
// output deploymentNames array = [for d in modelDeployments: d.name]
// output deploymentIds array = [for d in modelDeployments: d.id]
