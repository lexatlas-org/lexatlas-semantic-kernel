param solutionName string
param location string
param aiHubId string

var aiProjectName = 'proj-${solutionName}'

resource aiProject 'Microsoft.MachineLearningServices/workspaces@2024-01-01-preview' = {
  name: aiProjectName
  location: location
  kind: 'Project'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: aiProjectName
    hubResourceId: aiHubId
  }
}

output id string = aiProject.id
output name string = aiProject.name
output discoveryUrl string = contains(aiProject.properties, 'discoveryUrl') ? aiProject.properties.discoveryUrl : 'N/A'
