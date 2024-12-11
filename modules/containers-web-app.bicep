param location string = resourceGroup().location
param name string
param appServicePlanId string
param dockerRegistryName string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'
param appCommandLine string = ''
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string


resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
      appCommandLine: appCommandLine
      appSettings: [
        { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false' }
        { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
        { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
        { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
      ]
    }
  }
}


output appServiceAppHostName string = appServiceApp.properties.defaultHostName
