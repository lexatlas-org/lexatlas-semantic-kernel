param principalId string
param scope string
param roleDefinitionId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(scope, principalId, roleDefinitionId)
  scope: scope
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    principalType: 'ServicePrincipal'
  }
}

output id string = roleAssignment.id
