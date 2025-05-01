@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the Azure Cognitive Search resource will be deployed')
param location string

@description('SKU name for the Azure Cognitive Search resource (e.g., basic, standard, standard2)')
param skuName string = 'basic'

var name = 'search-${solutionName}'

// Azure Cognitive Search Resource
resource search 'Microsoft.Search/searchServices@2020-08-01' = {
  name: name
  location: location
  sku: { name: skuName }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
    publicNetworkAccess: 'enabled'
  }
}

@description('Resource ID of the deployed Azure Cognitive Search resource')
output id string = search.id

@description('Name of the deployed Azure Cognitive Search resource')
output name string = search.name

@description('Endpoint URL of the deployed Azure Cognitive Search resource')
output endpoint string = 'https://${search.name}.search.windows.net'

@description('Admin key for the deployed Azure Cognitive Search resource')
output adminKey string = listAdminKeys(search.id, '2020-08-01').primaryKey
