@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the storage account will be deployed')
param location string

@description('SKU name for the storage account (e.g., Standard_LRS, Standard_GRS, Premium_LRS)')
param skuName string = 'Standard_LRS'

var name = replace(toLower('st${solutionName}hub'), '-', '')

// Azure Storage Account Resource
resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  sku: { name: skuName }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    supportsHttpsTrafficOnly: true
    isHnsEnabled: false
    minimumTlsVersion: 'TLS1_2'
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: { enabled: true, keyType: 'Account' }
        file: { enabled: true, keyType: 'Account' }
      }
    }
    keyPolicy: {
      keyExpirationPeriodInDays: 7
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

@description('Resource ID of the deployed storage account')
output id string = storage.id

@description('Name of the deployed storage account')
output name string = storage.name
