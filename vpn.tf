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

resource "aws_vpn_gateway" "gateway" {
  vpc_id            = module.aws_server.vpc_id
  tags = merge(
    { "Name" = "vpn-gateway" },
  )
}

resource "aws_customer_gateway" "main" {
  bgp_asn    =  31898
  ip_address = "1.1.1.1"
  type       = "ipsec.1"

  tags = {
    Name = "complete-vpn-gateway"
  }
}
module "oci-aws-vpn" {
    providers = {
        aws = aws.us
        oci = oci.oci_us
    }
    source            = "./Modules/oci_aws_vpn_module"
    drgid = module.oraclenetwork.ocidrgid
    ocicompartment_id = var.oci_compartment_id
    vpn_gateway_id = aws_vpn_gateway.gateway.id

    depends_on        = [module.oraclenetwork, module.aws_server]
}


module "aws_server" {
    source = "./Modules/Aws_Module"
    providers = {
        aws = aws.us
    }

}