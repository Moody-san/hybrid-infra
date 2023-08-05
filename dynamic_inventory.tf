module "oracle_inventory" {
  source = "./Modules/Inventory_Module"
  templatepath  = "../ansible-k8s-deployment/templates/oracleinventory.tpl"
  inventorypath = "../ansible-k8s-deployment/inventory/oracleinventory"
  cloudservers  = module.oracleservers
  depends_on    = [module.oracleservers]
}

module "azure_inventory" {
  source = "./Modules/Inventory_Module"
  templatepath  = "../ansible-k8s-deployment/templates/azureinventory.tpl"
  inventorypath = "../ansible-k8s-deployment/inventory/azureinventory"
  cloudservers  = module.azureservers
  depends_on    = [module.azureservers]
}