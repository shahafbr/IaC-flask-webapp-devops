param appServicePlanName string
param appServiceWebsiteBEName string
param location string = resourceGroup().location
param containerRegistryName string
param dockerRegistryImageName string 
param dockerRegistryImageVersion string
param userAlias string
param appServicePlanSkuName string

module containerRegistry 'modules/acr.bicep' = {
  name: 'cr-${userAlias}'
  params: {
  name: containerRegistryName
  location: location
  }
  }
  module appServicePlan 'modules/app-service-plan.bicep' = {
  name: 'asp-${userAlias}'
  params: {
  location: location
  appServicePlanName: appServicePlanName
  skuName: appServicePlanSkuName
  }
  }
  module appServiceWebsiteBE 'modules/containers-web-app.bicep' = {
  name: 'appfe-${userAlias}'
  params: {
  name: appServiceWebsiteBEName
  location: location
  appServicePlanId: appServicePlan.outputs.id
  appCommandLine: ''
  dockerRegistryName: containerRegistryName
  dockerRegistryServerUserName: containerRegistry.outputs.containerRegistryUserName
  dockerRegistryServerPassword: containerRegistry.outputs.containerRegistryPassword0
  dockerRegistryImageName: dockerRegistryImageName
  dockerRegistryImageVersion: dockerRegistryImageVersion
  }
  dependsOn: [
  containerRegistry
  appServicePlan
  ]
  }
