resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.hostname}"
  location              = var.location
  resource_group_name   = var.rgname
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.azurenic.id]

  source_image_reference {
    offer     = local.source_image_reference.offer
    publisher = local.source_image_reference.publisher
    sku       = var.imagetype
    version   = local.source_image_reference.version
  }
  os_disk {
    name                 = "${var.hostname}-${var.os_disk.name}"
    caching              = var.os_disk.caching
    storage_account_type = var.diskstoragetype
    disk_size_gb         = var.diskstoragegbs
  }

  admin_username                  = var.username
  disable_password_authentication = true
  computer_name                   = var.hostname
  admin_ssh_key {
    username   = var.username
    public_key = file(var.ssh_key)
  }
}