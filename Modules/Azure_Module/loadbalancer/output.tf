output "public_ip" {
  value = azurerm_public_ip.lbpublicip.ip_address
}