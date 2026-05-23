// This is a Bicep file
//It desscribes Azure resources we want to create

//param means parameter - a value we pass in when deploying
//This lets us reuse the same file for different enviroments

param location string = 'eastus'

//Another parameter for enviroment name
//Default is  'dev' but can be changed to 'prod' later

param environmentName string = 'dev'

//param for project name

param projectName string = 'playspot'

//Variable -- calulated values used throughout the file
//storageAccountName combies our parameters into one name
var storageAccountName = '${projectName}storage${environmentName}001'

//keyVaultName follows Azure naming convertion with hyphens
var keyVaultName = '${projectName}-kv-${environmentName}'

// tags variable applies same tags to every resource
// define once and reference everywhere
// much cleaner than repeating tags in every resource

var tags = {
  Project: projectName
  Environment: environmentName
  Owner: 'Oscar'
  Version: '1.0'
}


// resource keyword tells Bicep we are creating something
// storageAccount is the name WE give this resource in Bicep
// 'Microsoft.Storage/storageAccounts@2023-01-01' tells Azure
// what type of resource and which API version to use
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  
  // name of the actual storage account in Azure
  // we combine projectName and environmentName to make it unique
  name: storageAccountName
  
  // where to create it - uses our location parameter
  location: location
  
  // sku means Stock Keeping Unit - basically the pricing tier
  sku: {
    // Standard_LRS means Standard Locally Redundant Storage
    // same choice we made when creating storage manually
    name: 'Standard_LRS'
  }
  
  // kind means what type of storage account
  // StorageV2 is the modern general purpose version
  kind: 'StorageV2'
  
  // properties are additional settings for this resource
  properties: {
    // Cool access tier costs less for infrequently accessed data
    accessTier: 'Cool'
  }
  
  // reference the tags variable instead of repeating
  tags: tags

}

// Key Vault resource - stores secrets securely
// We already have playspot-kv manually created
// This Bicep version lets us recreate it automatically
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {

  // uses our keyVaultName variable defined at the top
  name: keyVaultName

  // uses our location parameter
  location: location

  // apply our standard tags
  tags: tags

  // properties define how Key Vault behaves
  properties: {

    // sku defines the pricing tier
    // standard is fine for our use case
    sku: {
      family: 'A'
      name: 'standard'
    }

    // tenantId is required - tells Key Vault which
    // Azure AD tenant it belongs to
    // subscription().tenantId gets it automatically
    // so we never have to hardcode it
    tenantId: subscription().tenantId

    // enabledForDeployment allows Azure VMs to
    // retrieve certificates from Key Vault
    enabledForDeployment: false

    // softDeleteRetentionInDays means deleted secrets
    // can be recovered for this many days
    // we set 7 for dev environment to save cost
    softDeleteRetentionInDays: 7

    // accessPolicies controls who can access secrets
    // empty for now we will add policies separately
    accessPolicies: []
  }
}


//Outputs - values returned after deployment completes
//This returns the storage account name so other scripts can use it 
output storageAccountName string = storageAccount.name

//this returns the storage account endpoint URL
output storageAccountEndpoint string = storageAccount.properties.primaryEndpoints.blob

// returns the Key Vault URI so other scripts can reference it
output keyVaultUri string = keyVault.properties.vaultUri

// returns the Key Vault name for reference
output keyVaultResourceName string = keyVault.name
