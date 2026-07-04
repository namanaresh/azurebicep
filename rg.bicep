// Parameters
param rgName string = 'az104rg'
param location string = 'eastus'
param vmName string = 'myVM'
param adminUsername string = 'azureuser'
param subnet string = 'az104sub'
@secure()
param adminPassword string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: '${rgName}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Public IP
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${vmName}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
