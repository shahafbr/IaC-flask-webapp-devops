param location string = resourceGroup().location
param appServicePlanName string

@allowed([
'B1'
'F1'
])

param skuName string
resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
name: appServicePlanName
location: location
sku: {
name: skuName
tier: 'Basic'
size: 'B1'
family: 'B'
capacity: 1
}
kind: 'linux'
properties: {
reserved: true
}
}
output id string = appServicePlan.id
