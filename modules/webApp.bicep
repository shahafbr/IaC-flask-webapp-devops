@description('Deploy an Azure Web App for Linux containers')
param name string
param location string
param kind string = 'app'
param serverFarmResourceId string
param siteConfig object
param appSettingsKeyValuePairs object

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource appSettings 'Microsoft.Web/sites/config@2021-02-01' = {
  parent: webApp
  name: 'appsettings'
  properties: appSettingsKeyValuePairs
}
