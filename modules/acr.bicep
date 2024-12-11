@description('Deploy an Azure Container Registry')
param name string
param location string = resourceGroup().location

@description('The name of the Key Vault where credentials will be stored')
param keyVaultName string

@secure()
param keyVaultSecretAdminUsername string
@secure()
param keyVaultSecretAdminPassword string


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
  dependsOn: [
    adminCredentialsKeyVault
  ]
}

// Define the Key Vault as a direct resource
resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: keyVaultName
  scope: resourceGroup()
}

// Store the ACR admin username in the Key Vault
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: keyVaultSecretAdminUsername
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
  }
}

// Store the first ACR admin password in the Key Vault
resource secretAdminUserPassword 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: keyVaultSecretAdminPassword
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
  }
}

// Output the ACR login server
output acrLoginServer string = containerRegistry.properties.loginServer
// Output the ACR name
output containerRegistryName string = containerRegistry.name
