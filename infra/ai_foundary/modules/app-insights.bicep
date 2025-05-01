@description('Name prefix of the solution')
param solutionName string

@description('Azure region where the Application Insights instance will be deployed')
param location string

@description('Resource ID of the Log Analytics Workspace to link with Application Insights')
param logAnalyticsId string

var name = 'appi-${solutionName}'

// Application Insights Resource
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: logAnalyticsId
  }
}

@description('Resource ID of the deployed Application Insights instance')
output id string = appInsights.id

@description('Name of the deployed Application Insights instance')
output name string = appInsights.name
