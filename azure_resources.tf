module "azure_server_1" {
  source = "./Modules/Azure_Module"
  providers = {
    azurerm = azurerm.azure_ind
  }
  ssh_key = var.ssh_key
}

output "azure_server_public_ip_1" {
  value = module.azure_server_1.azure_server_public_ip
}