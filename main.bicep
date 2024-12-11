param containerRegistryName string
param location string
param webAppName string
param appServicePlanName string
param containerRegistryImageName string 
param containerRegistryImageVersion string
param keyVaultName string
@secure()
param keyVaultSecretAdminUsername string
@secure()
param keyVaultSecretAdminPassword string


// Deploy Azure Container Registry
module acr './modules/acr.bicep' = {
  name: 'deployAcr'
  params: {
    name: containerRegistryName
    location: location
    keyVaultName: keyVaultName
    keyVaultSecretAdminUsername: keyVaultSecretAdminUsername
    keyVaultSecretAdminPassword: keyVaultSecretAdminPassword
  }
}

// Deploy App Service Plan
module appServicePlan './modules/appServicePlan.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
      reserved: true
    }
  }
}

// Deploy Web App
module webApp './modules/webApp.bicep' = {
  name: 'deployWebApp'
  params: {
    name: webAppName
    location: location
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.outputs.acrLoginServer}/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: acr.outputs.acrLoginServer
      DOCKER_REGISTRY_SERVER_USERNAME: keyVaultSecretAdminUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: keyVaultSecretAdminPassword
    }
  }
}

