param env string                                 // Specifing the environment 
param objectId string                            // Unique id of Service principal being used to deploy resources , We can find it in Entra ID.           
param tenantId string = subscription().tenantId  // unique universal id of your application , this you can find in the Microsoft EntraID section.
param location string = resourceGroup().location // Location where we are deploying the resources. 
param resourceTags object = {                    // Specific tags required to distinguish our application
  BU1: ''
  application: ''
  team: ''
}

// Deployed Application Insights to log the information about performance and failures of api.

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-sample-${env}'
  location: location
  tags: resourceTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: loganalytics.id      // After new update of the Microsoft , We have to deploy log ananlytics in support of application insights to function.
  }
}

// Deployed KeyVault to contain secrets value that we can pass via different ways in our application.

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-sample-${env}'
  location: location
  tags: resourceTags
  properties: {
    softDeleteRetentionInDays: 90
    enableSoftDelete: true
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objectId
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
            'purge'
          ]
          certificates: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'managecontacts'
            'manageissuers'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
          ]
        }
      }
      {
        tenantId: tenantId
        objectId: objectId
        permissions: {
          secrets: [
            'list'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}
// Log analytics workspace to conatin logs.

resource loganalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'log-sample-${env}'
  tags: resourceTags
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    features: {
      immediatePurgeDataOn30Days: true
    }
      publicNetworkAccessForIngestion: 'Enabled'
      publicNetworkAccessForQuery: 'Enabled'
  }
}

// Creating Key Vault Logs to store all the information / metadata about operations being performed on the keyvault.

resource keyvaultdiagnostic 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'diags-all-logs'
  scope: keyVault
  properties: {
    workspaceId: loganalytics.id
    logs: [
      {
        categoryGroup: 'audit'
        enabled: true
      }
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
      ]
    }
}


