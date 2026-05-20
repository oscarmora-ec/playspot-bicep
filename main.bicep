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

// resource keyword tells Bicep we are creating something
// storageAccount is the name WE give this resource in Bicep
// 'Microsoft.Storage/storageAccounts@2023-01-01' tells Azure
// what type of resource and which API version to use
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  
  // name of the actual storage account in Azure
  // we combine projectName and environmentName to make it unique
  name: '${projectName}storage${environmentName}001'
  
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
  
  // tags help organize and track resources
  // same tags we apply to everything in PlaySpot
  tags: {
    Project: projectName
    Environment: environmentName
    Owner: 'Oscar'
  }
}