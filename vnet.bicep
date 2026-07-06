targetScope = 'resourceGroup'

param vnetName string = 'az104VNet'
param location string = 'eastus'
param addressSpace array = [
  '10.0.0.0/16'
]

param subnetName string = 'az104sub'
param subnetPrefix string = '10.0.0.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}
