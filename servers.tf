locals {
  oracleservers = [
    # {
    #   display_name = "oraclemaster"
    #   cpu          = 1
    #   memory       = 6
    #   image        = var.oci_image_id
    # },
    # {
    #   display_name = "oracleworker"
    #   cpu          = 1
    #   memory       = 6
    #   image        = var.oci_image_id
    # },
    # {
    #   display_name = "oracleworker2"
    #   cpu          = 1
    #   memory       = 6
    #   image        = var.oci_image_id
    # },
    {
      display_name = "oracledb"
      cpu          = 1
      memory       = 6
      image        = var.oci_dbimage_id
    }
  ]
}


variable "azureservers" {
  default = [
    # {
    #   hostname  = "azuremaster"
    #   diskgb    = 64
    #   disktype  = "Standard_LRS"
    #   vm_size   = "Standard_B2s"
    #   imagetype = "22_04-lts-gen2"
    #   imagename = "jammy"
    # },
    {
      hostname  = "azuredb"
      diskgb    = 64
      disktype  = "Premium_LRS"
      vm_size   = "Standard_B2s"
      imagetype = "20_04-lts-gen2"
      imagename = "focal"
    }
  ]
}