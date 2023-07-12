terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}