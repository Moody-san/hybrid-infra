module "oci-azure-vpn" {
  providers = {
    azurerm = azurerm.azure_st
    oci     = oci.oci_us
  }
  source            = "./Modules/Vpn_Module"
  ocicompartment_id = var.compartment_id
  drgid             = module.oraclenetwork.drgid
  azurelocation     = module.azurenetwork.location
  azurergname       = module.azurenetwork.name
  azurevcnname      = module.azurenetwork.vcnname
  depends_on        = [module.oraclenetwork, module.azurenetwork]
}