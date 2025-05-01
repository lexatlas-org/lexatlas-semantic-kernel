@description('Name of the key vault.')
param keyVaultName string

@description('Specifies the location for the key vault.')
param location string

@description('Specifies the access policies for the key vault.')
param accessPolicies array = []

resource keyVaultResource 'Microsoft.KeyVault/vaults@2022-07-01' =  {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: accessPolicies
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

output keyVaultId string = keyVaultResource.id
output keyVaultUri string = keyVaultResource.properties.vaultUri
