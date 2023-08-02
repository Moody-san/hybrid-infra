variable "oracleservers" {
  default = [
    {
      display_name = "oraclemaster"
      cpu          = 2
      memory       = 8
    },
    {
      display_name = "oracleworker"
      cpu          = 1
      memory       = 8
    },
    {
      display_name = "oraclemaster2"
      cpu          = 1
      memory       = 8
    }
  ]
}


variable "azureservers" {
  default = [
    {
      hostname  = "azuremaster"
      diskgb    = 64
      disktype  = "Premium_LRS"
      vm_size   = "Standard_B2als_v2"
      imagetype = "22_04-lts-gen2"
    },
    {
      hostname  = "azureworker"
      diskgb    = 64
      disktype  = "Premium_LRS"
      vm_size   = "Standard_B2als_v2"
      imagetype = "22_04-lts-gen2"
    }
  ]
}