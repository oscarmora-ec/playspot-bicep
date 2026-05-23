// Storage Account Module
// This module is responsible for creating a storage account
// It can be called from any Bicep file that needs storage

// Parameters this module accepts
// These are passed in from the parent file (main.bicep)
param location string
param storageAccountName string
param tags object

// The storage account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Cool'
  }
}

// Output the storage account name and endpoint
// Parent file can read these after module deploys
output storageAccountName string = storageAccount.name
output storageAccountEndpoint string = storageAccount.properties.primaryEndpoints.blob
