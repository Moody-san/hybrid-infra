output "azure_server_public_ip" {
  value = azurerm_public_ip.azurepubip.ip_address
}