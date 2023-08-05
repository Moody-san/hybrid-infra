module "azurenetwork" {
  source = "./Modules/Azure_Module/network"
  providers = {
    azurerm = azurerm.azure_st
  }
}

module "azureservers" {
  providers = {
    azurerm = azurerm.azure_st
  }
  source          = "./Modules/Azure_Module/compute"
  for_each        = { for server in var.azureservers : server.hostname => server }
  hostname        = each.value.hostname
  diskstoragegbs  = each.value.diskgb
  diskstoragetype = each.value.disktype
  vm_size         = each.value.vm_size
  imagetype       = each.value.imagetype
  ssh_key         = var.ssh_key
  location        = module.azurenetwork.location
  rgname          = module.azurenetwork.name
  subnet_id       = module.azurenetwork.subnet_id
  depends_on      = [module.azurenetwork]
}

output "azure_server_public_ip" {
  value = { for k, v in module.azureservers : k => v.public_ip }
}

