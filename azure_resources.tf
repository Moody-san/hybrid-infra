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
  subnet_id       = module.azurenetwork.azureprivatesubnet_id
  imagename       = each.value.imagename
  depends_on      = [module.azurenetwork]
}

module "azurelb" {
  source = "./Modules/Azure_Module/loadbalancer"
  providers = {
    azurerm = azurerm.azure_st
  }
  location     = module.azurenetwork.location
  rgname       = module.azurenetwork.name
  azureservers = module.azureservers
  azurevnetid  = module.azurenetwork.azurevnet_id
  depends_on   = [module.azureservers]
}

output "azure_servers" {
  value = module.azureservers
}

