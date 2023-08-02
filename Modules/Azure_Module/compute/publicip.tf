resource "azurerm_public_ip" "azurepubip" {
  name                = "${var.prefix}pubip${var.hostname}"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = var.pub_ip_type
}