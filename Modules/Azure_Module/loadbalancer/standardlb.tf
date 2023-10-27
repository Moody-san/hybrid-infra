resource "azurerm_public_ip" "lbpublicip" {
  name                = "lbpublicip"
  resource_group_name = var.rgname
  location            = var.location
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "slb" {
  name                = "standardlb"
  resource_group_name = var.rgname
  location            = var.location
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "lbfrontendip"
    public_ip_address_id = azurerm_public_ip.lbpublicip.id
  }
}
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name                = "lbbackendpool"
  loadbalancer_id     = azurerm_lb.slb.id
}

resource "azurerm_lb_probe" "lbhealthprobe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 31736
  loadbalancer_id     = azurerm_lb.slb.id
}

resource "azurerm_lb_rule" "lbrules" {
  name                           = "lbrule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.slb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lbhealthprobe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_address_pool.id]
  loadbalancer_id                = azurerm_lb.slb.id
}


resource "azurerm_lb_backend_address_pool_address" "backendip" {
  count = length(local.instances)
  name                                = "backend${local.instances[count.index].server_name}"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
  virtual_network_id = var.azurevnetid
  ip_address = local.instances[count.index].ip_address
}

