// Cosmos DB Module
// Responsible for creating Cosmos DB account,
// database and container for PlaySpot activities

// Parameters passed in from main.bicep
param location string
param accountName string
param tags object

// Cosmos DB Account resource
resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {

  name: accountName
  location: location
  tags: tags

  // kind DocumentDB is the default NoSQL API
  kind: 'GlobalDocumentDB'

  properties: {

    // consistencyPolicy defines how data is replicated
    // Session is the default and works well for most apps
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }

    // locations defines where data is stored
    // we use one location to minimize cost
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]

    // capabilities defines special features
    // EnableServerless means pay per request not per hour
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]

    // disableKeyBasedMetadataWriteAccess improves security
    // prevents accidental changes via account keys
    disableKeyBasedMetadataWriteAccess: false
  }
}

// Cosmos DB Database resource
// depends on the account above being created first
resource cosmosDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {

  // parent tells Bicep this lives inside the account
  parent: cosmosAccount

  name: 'playspot-database'

  properties: {
    resource: {
      id: 'playspot-database'
    }
  }
}

// Cosmos DB Container resource
// depends on the database above being created first
resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {

  // parent tells Bicep this lives inside the database
  parent: cosmosDatabase

  name: 'activities'

  properties: {
    resource: {

      id: 'activities'

      // partition key helps Cosmos DB organize data efficiently
      // we partition by type (Indoor/Outdoor)
      // same choice we made when creating manually
      partitionKey: {
        paths: [
          '/type'
        ]
        kind: 'Hash'
      }
    }
  }
}

// Outputs returned to main.bicep
output cosmosAccountName string = cosmosAccount.name
output cosmosEndpoint string = cosmosAccount.properties.documentEndpoint
