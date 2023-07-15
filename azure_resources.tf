# module "azure_server_1" {
#   source = "./Modules/Azure_Module"
#   providers = {
#     azurerm = azurerm.azure_ind
#   }
#   ssh_key = var.ssh_key
#   pub_ip_type = "Dynamic"
# }

# output "azure_server_public_ip_1" {
#   value = module.azure_server_1.azure_server_public_ip
# }

# module "azure_server_2" {
#   source = "./Modules/Azure_Module"
#   providers = {
#     azurerm = azurerm.azure_ind_2
#   }
#   ssh_key = var.ssh_key
#   prefix = "azure_2"
#   pub_ip_type = "Dynamic"
# }

# output "azure_server_public_ip_2" {
#   value = module.azure_server_2.azure_server_public_ip
# }
