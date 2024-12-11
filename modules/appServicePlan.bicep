@description('Deploy an Azure App Service Plan')
param name string
param location string
param sku object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  location: location
  sku: sku
  kind: 'Linux'
  properties: {
    reserved: true
  }
}
