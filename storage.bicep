param env string 
param sku string = 'Standard_LRS'
param location string = resourceGroup().location
param resourceTags object = {
  application: ''
  team: ''
}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'stsamplestorage{env}'
  location: location
  tags: resourceTags // It will take the same of Resource Group location.
  kind: 'StorageV2'
  sku: {
    name: sku   // Defined in Line no . 2 
  }
  properties: {
    allowBlobPublicAccess: false // Public access is disabled.
    minimumTlsVersion: 'TLS1_2'
  }
}
