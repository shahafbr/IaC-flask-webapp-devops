param name string
param location string = resourceGroup().location

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output containerRegistryUserName string = containerRegistry.listCredentials().username
output containerRegistryPassword0 string = containerRegistry.listCredentials().passwords[0].value
output containerRegistryPassword1 string = containerRegistry.listCredentials().passwords[1].value
