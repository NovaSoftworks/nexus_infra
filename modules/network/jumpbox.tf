# Subnet
resource "azurerm_subnet" "jumpbox_subnet" {
  name                 = "jumpbox"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  address_prefixes     = ["10.10.10.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "novacp-${var.environment}-${var.region_short}-nexus-vnet-jumpbox-nsg"
  resource_group_name = azurerm_resource_group.vnet_rg.name
  location            = azurerm_resource_group.vnet_rg.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "jumpbox_nsg_association" {
  subnet_id                 = azurerm_subnet.jumpbox_subnet.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

output "jumpbox_subnet_id" {
  value       = azurerm_subnet.jumpbox_subnet.id
  description = "The ID of the subnet to which the Jumpbox will be connected."
}
