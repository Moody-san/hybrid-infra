module "oracle_inventory" {
  source           = "./Modules/Inventory_Module/k8sinventory"
  k8stemplatepath  = "../ansible-k8s-deployment/templates/oracleinventory.tpl"
  k8sinventorypath = "../ansible-k8s-deployment/inventory/oracleinventory"

  cloudservers     = module.oracleservers
  depends_on       = [module.oracleservers]
}

module "azure_inventory" {
  source           = "./Modules/Inventory_Module/k8sinventory"
  k8stemplatepath  = "../ansible-k8s-deployment/templates/azureinventory.tpl"
  k8sinventorypath = "../ansible-k8s-deployment/inventory/azureinventory"
  cloudservers     = module.azureservers
  depends_on       = [module.azureservers]
}

module "db_inventory" {
  source           = "./Modules/Inventory_Module/dbinventory"
  dbtemplatepath  = "../ansible-couchdb-deployment/templates/inventory.tpl"
  dbinventorypath = "../ansible-couchdb-deployment/inventory/inventory"
  azureservers    = module.azureservers
  oracleservers     = module.oracleservers
  depends_on       = [module.azureservers,module.oracleservers]
}