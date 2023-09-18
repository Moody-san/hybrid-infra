# module "oci-azure-vpn" {
#   providers = {
#     azurerm = azurerm.azure_st
#     oci     = oci.oci_us
#   }
#   source            = "./Modules/Vpn_Module"
#   ocicompartment_id = var.oci_compartment_id
#   drgid             = module.oraclenetwork.ocidrgid
#   azurelocation     = module.azurenetwork.location
#   azurergname       = module.azurenetwork.name
#   azurevcnname      = module.azurenetwork.vcnname
#   depends_on        = [module.oraclenetwork, module.azurenetwork]
# }


module "oci-aws-vpn" {
    providers = {
        aws = aws.us
        oci = oci.oci_us
    }
    source            = "./Modules/oci_aws_vpn_module"
    ocicompartment_id = var.oci_compartment_id
    depends_on        = [module.oraclenetwork]
}


module "aws_server" {
    source = "./Modules/Aws_Module"
    providers = {
        aws = aws.us
    }
    subnet_id = module.azurenetwork.subnet_id
    depends_on = [module.azurenetwork]
}