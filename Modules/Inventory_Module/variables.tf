
variable "oracleservers" {

}

variable "azureservers" {

}

variable "oraclek8stemplatepath"{

}
variable "oraclek8sinventorypath"{
    
}

variable "azurek8stemplatepath"{

}
variable "azurek8sinventorypath"{
    
}
variable "dbtemplatepath"{

}
variable "dbinventorypath"{

} 

locals {
    allservers={
        ociservers = [for server in var.oracleservers : server.server_details],
        ocibastionpubip = [for server in var.oracleservers : server.server_details.public_ip if server.server_details.is_oracle_bastion == true],
        azservers = [for server in var.azureservers : server.server_details]
    }
    azureips = [for detail in local.allservers.azservers : detail.private_ip]
    oracleips = [for detail in local.allservers.ociservers : detail.private_ip]
}