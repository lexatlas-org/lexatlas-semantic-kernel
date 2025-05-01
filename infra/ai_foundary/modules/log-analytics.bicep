@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the Log Analytics Workspace will be deployed')
param location string

@description('Retention period in days for the Log Analytics Workspace (default: 30)')
@minValue(7)
@maxValue(730)
param retentionInDays int = 30

var name = 'log-${solutionName}'

// Log Analytics Workspace Resource
resource log 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  properties: {
    retentionInDays: retentionInDays
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

@description('Resource ID of the deployed Log Analytics Workspace')
output id string = log.id

@description('Name of the deployed Log Analytics Workspace')
output name string = log.name

@description('Customer ID of the deployed Log Analytics Workspace')
output customerId string = log.properties.customerId
