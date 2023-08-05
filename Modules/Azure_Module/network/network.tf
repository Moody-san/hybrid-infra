resource "azurerm_resource_group" "azurerg" {
  name     = "${var.prefix}rg"
  location = var.region
}

resource "azurerm_virtual_network" "azurevcn" {
  name                = "${var.prefix}vcn"
  address_space       = [var.cidr_ip_block]
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name
}

resource "azurerm_subnet" "applicationsubnet" {
  name                 = "applicationsubnet"
  resource_group_name  = azurerm_resource_group.azurerg.name
  virtual_network_name = azurerm_virtual_network.azurevcn.name
  address_prefixes     = [var.cidr_ip_subnet]
}

resource "azurerm_network_security_group" "azurensg" {
  name                = "application-nsg"
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name

  security_rule {
    name                       = "ingress_rules_all_allowed"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    priority                   = 100
    name                       = "egress_rules_all_allowed"
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "azurensgsubnet" {
  subnet_id                 = azurerm_subnet.applicationsubnet.id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}