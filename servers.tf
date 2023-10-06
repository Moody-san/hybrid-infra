locals {
  oracleservers = [
    {
      display_name     = "oraclemaster"
      cpu              = 1
      memory           = 6
      image            = var.oci_ubuntu22_id
      boot_volume      = 50
      assign_public_ip = false
      subnet_id        = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name     = "oracleworker"
      cpu              = 1
      memory           = 6
      image            = var.oci_ubuntu22_id
      boot_volume      = 50
      assign_public_ip = false
      subnet_id        = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name     = "oracledb"
      cpu              = 1
      memory           = 6
      image            = var.oci_ubuntu20_id
      boot_volume      = 50
      assign_public_ip = false
      subnet_id        = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name     = "oraclebastion"
      cpu              = 1
      memory           = 6
      image            = var.oci_ubuntu22_id
      boot_volume      = 50
      assign_public_ip = true
      subnet_id        = module.oraclenetwork.ocipublicsubnet_id
    }
  ]
}


# variable "azureservers" {
#   default = [
#     {
#       hostname  = "azuremaster"
#       diskgb    = 64
#       disktype  = "Premium_LRS"
#       vm_size   = "Standard_B2s"
#       imagetype = "22_04-lts-gen2"
#       imagename = "jammy"
#     },
#     {
#       hostname  = "azuredb"
#       diskgb    = 64
#       disktype  = "Premium_LRS"
#       vm_size   = "Standard_B2s"
#       imagetype = "20_04-lts-gen2"
#       imagename = "focal"
#     }
#   ]
# }