terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.0.0"
    }
  }
  backend "s3" {
      bucket = "hybridinfrastatebucket"
      dynamodb_table ="hybridinfrastatelockdb"
      key = "remote_backend/terraform.tfstate"
      region = "us-east-1"
      encrypt = true
  }
}


provider "aws" {
  region = "us-east-1"
  alias  = "us"
}


provider "oci" {
  region="us-phoenix-1"
  alias="oci_us"
}


