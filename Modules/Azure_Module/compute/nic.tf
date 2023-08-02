resource "azurerm_network_interface" "azurenic" {
  name                = "${var.prefix}nic${var.hostname}"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "${var.prefix}_ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.pvt_ip_type
    public_ip_address_id          = azurerm_public_ip.azurepubip.id
  }
}