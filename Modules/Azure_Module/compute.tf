resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.prefix}vm"
  location              = azurerm_resource_group.azurerg.location
  resource_group_name   = azurerm_resource_group.azurerg.name
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.azurenic.id]

  source_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    name                 = "myosdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 64
  }

  admin_username                  = var.username
  disable_password_authentication = true
  computer_name                   = var.username
  admin_ssh_key {
    username   = var.username
    public_key = file(var.ssh_key)
  }
}