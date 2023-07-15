resource "azurerm_resource_group" "azurerg" {
  name     = "${var.prefix}_rg"
  location = var.region
}

resource "azurerm_virtual_network" "azurevcn" {
  name                = "${var.prefix}_vcn"
  address_space       = [var.cidr_ip_block]
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.azurerg.name
  virtual_network_name = azurerm_virtual_network.azurevcn.name
  address_prefixes     = [var.cidr_ip_subnet]
}

resource "azurerm_public_ip" "azurepubip" {
  name                = "${var.prefix}_pubip"
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name
  allocation_method   = var.pub_ip_type
}

resource "azurerm_network_interface" "azurenic" {
  name                = "${var.prefix}_nic"
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name

  ip_configuration {
    name                          = "${var.prefix}_ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azurepubip.id
  }
}


resource "azurerm_network_security_group" "azurensg" {
  name                = "${var.prefix}_nsg"
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

  # dynamic "security_rule" {
  #   for_each = { for option in var.tcp_options : option.port => option }
  #   content {
  #     priority                   = security_rule.value.priority
  #     name                       = "${var.prefix}_inbound_rule_${security_rule.value.port}"
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = security_rule.value.port
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   }
  # }
}

resource "azurerm_subnet_network_security_group_association" "azurensgsubnet" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}