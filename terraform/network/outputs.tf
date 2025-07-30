# Network Module Outputs

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.network.name
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value = {
    prod  = azurerm_subnet.prod.id
    test  = azurerm_subnet.test.id
    dev   = azurerm_subnet.dev.id
    admin = azurerm_subnet.admin.id
  }
}

output "subnet_address_spaces" {
  description = "Address spaces of all subnets"
  value = {
    prod  = azurerm_subnet.prod.address_prefixes
    test  = azurerm_subnet.test.address_prefixes
    dev   = azurerm_subnet.dev.address_prefixes
    admin = azurerm_subnet.admin.address_prefixes
  }
}

output "nsg_ids" {
  description = "IDs of all network security groups"
  value = {
    prod  = azurerm_network_security_group.prod.id
    test  = azurerm_network_security_group.test.id
    dev   = azurerm_network_security_group.dev.id
    admin = azurerm_network_security_group.admin.id
  }
}

output "network_config" {
  description = "Complete network configuration"
  value = {
    resource_group_name = azurerm_resource_group.network.name
    vnet_name           = azurerm_virtual_network.main.name
    vnet_id             = azurerm_virtual_network.main.id
    vnet_address_space  = azurerm_virtual_network.main.address_space
    subnets = {
      prod = {
        id               = azurerm_subnet.prod.id
        address_prefixes = azurerm_subnet.prod.address_prefixes
        nsg_id           = azurerm_network_security_group.prod.id
      }
      test = {
        id               = azurerm_subnet.test.id
        address_prefixes = azurerm_subnet.test.address_prefixes
        nsg_id           = azurerm_network_security_group.test.id
      }
      dev = {
        id               = azurerm_subnet.dev.id
        address_prefixes = azurerm_subnet.dev.address_prefixes
        nsg_id           = azurerm_network_security_group.dev.id
      }
      admin = {
        id               = azurerm_subnet.admin.id
        address_prefixes = azurerm_subnet.admin.address_prefixes
        nsg_id           = azurerm_network_security_group.admin.id
      }
    }
  }
} 