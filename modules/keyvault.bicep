// Key Vault Module
// Responsible for creating a Key Vault instance
// Called from main.bicep

// Parameters passed in from parent file
param location string
param keyVaultName string
param tags object

// Key Vault resource
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {

  name: keyVaultName
  location: location
  tags: tags

  properties: {

    // sku tier - standard is fine for our use case
    sku: {
      family: 'A'
      name: 'standard'
    }

    // gets tenant ID automatically from subscription
    tenantId: subscription().tenantId

    // not needed for our use case
    enabledForDeployment: false

    // 7 days recovery window for dev environment
    softDeleteRetentionInDays: 7

    // empty access policies for now
    accessPolicies: []
  }
}

// Outputs returned to parent file
output keyVaultUri string = keyVault.properties.vaultUri
output keyVaultResourceName string = keyVault.name
