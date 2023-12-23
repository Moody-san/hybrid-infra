terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "5.19.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
 }

}


provider "oci" {
  region = "us-phoenix-1"
  alias  = "oci_us"
}

provider "azurerm" { // using paid version of azurerm provider currently change to student subscription
  features {}
  subscription_id = var.az_subscription_id
  client_id       = var.az_client_id
  client_secret   = var.az_client_secret
  tenant_id       = var.az_tenant_id
  alias           = "azure_st"
}
