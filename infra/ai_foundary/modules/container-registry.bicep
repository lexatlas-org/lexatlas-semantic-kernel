@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the Azure Container Registry will be deployed')
param location string

@description('SKU name for the Azure Container Registry (e.g., Basic, Standard, Premium)')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Premium'

var name = toLower(replace('cr-${solutionName}', '-', ''))

// Azure Container Registry Resource
resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  sku: { 
    name: skuName 
  }
  properties: {
    adminUserEnabled: true
    publicNetworkAccess: 'Disabled'
    zoneRedundancy: skuName == 'Premium' ? 'Enabled' : 'Disabled'
    dataEndpointEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSet: { 
      defaultAction: 'Deny' 
    }
    policies: {
      quarantinePolicy: { 
        status: 'enabled' 
      }
      retentionPolicy: { 
        status: 'enabled'
        days: 7 
      }
      trustPolicy: { 
        status: 'disabled'
        type: 'Notary' 
      }
    }
  }
}

@description('Resource ID of the deployed Azure Container Registry')
output id string = acr.id

@description('Name of the deployed Azure Container Registry')
output name string = acr.name

@description('Login server URL of the deployed Azure Container Registry')
output loginServer string = acr.properties.loginServer
