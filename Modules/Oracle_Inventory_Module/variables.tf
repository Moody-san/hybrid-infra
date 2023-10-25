
variable "oracleservers" {

}

variable "oraclek8stemplatepath"{

}
variable "oraclek8sinventorypath"{
    
}


variable "dbtemplatepath"{

}
variable "dbinventorypath"{

} 

locals {
    allservers={
        ociservers = [for server in var.oracleservers : server.server_details],
        ocibastionpubip = [for server in var.oracleservers : server.server_details.public_ip if server.server_details.is_oracle_bastion == true],
        oracleips = [for server in var.oracleservers : server.server_details.private_ip if server.server_details.is_oracle_bastion == false]
    }
}