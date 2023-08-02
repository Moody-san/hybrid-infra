output "location" {
  value = azurerm_resource_group.azurerg.location
}

output "name" {
  value = azurerm_resource_group.azurerg.name
}

output "subnet_id" {
  value = azurerm_subnet.internal.id
}

