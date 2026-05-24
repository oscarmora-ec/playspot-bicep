// Main Bicep file - PlaySpot Infrastructure
// This file orchestrates all modules
// Each module is responsible for one resource type

// Parameters - inputs from outside
param location string = 'eastus'
param environmentName string = 'dev'
param projectName string = 'playspot'

// Variables - calculated values used throughout
var storageAccountName = '${projectName}storage${environmentName}001'
var keyVaultName = '${projectName}-kv-${environmentName}'

// Tags applied to all resources
var tags = {
  Project: projectName
  Environment: environmentName
  Owner: 'Oscar'
  Version: '1.0'
}

// Cosmos DB account name
var cosmosAccountName = '${projectName}-db-${environmentName}'


// Storage Account Module
// calls our storage.bicep module and passes values in
module storage './modules/storage.bicep' = {

  // name of this module deployment
  name: 'storageDeployment'

  // params passes values into the module
  params: {
    location: location
    storageAccountName: storageAccountName
    tags: tags
  }
}

// Key Vault Module
// calls our keyvault.bicep module and passes values in
module keyVault './modules/keyvault.bicep' = {

  // name of this module deployment
  name: 'keyVaultDeployment'

  // params passes values into the module
  params: {
    location: location
    keyVaultName: keyVaultName
    tags: tags
  }
}

// Cosmos DB Module
// calls our cosmosdb.bicep module and passes values in
module cosmos './modules/cosmosdb.bicep' = {

  // name of this module deployment
  name: 'cosmosDeployment'

  // params passes values into the module
  params: {
    location: location
    accountName: cosmosAccountName
    tags: tags
  }
}


// Outputs - read from module outputs
// notice we use module name dot outputs dot output name
output storageAccountName string = storage.outputs.storageAccountName
output storageAccountEndpoint string = storage.outputs.storageAccountEndpoint
output keyVaultUri string = keyVault.outputs.keyVaultUri
output keyVaultResourceName string = keyVault.outputs.keyVaultResourceName

// Cosmos DB outputs
output cosmosAccountName string = cosmos.outputs.cosmosAccountName
output cosmosEndpoint string = cosmos.outputs.cosmosEndpoint

// Updated to trigger GitHub Actions deployment
