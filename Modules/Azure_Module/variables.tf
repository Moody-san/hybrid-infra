variable "region" {
  default = "centralindia"
}

variable "prefix" {
  default = "azure_1"
}

variable "cidr_ip_block" {
  default = "12.0.0.0/16"
}

variable "cidr_ip_subnet" {
  default = "12.0.1.0/24"
}

# variable "tcp_options" {
#   default = [
#     {
#       port     = "22"
#       priority = "101"
#     },
#     {
#       port     = "443"
#       priority = "102"
#     },
#     {
#       port     = "80"
#       priority = "103"
#     },
#   ]
# }

variable "vm_size" {
  default = "Standard_B1s"
}

variable "username" {
  default = "ubuntu"
}

variable "pub_ip_type" {
  default = "Dynamic"
}

variable "ssh_key" {

}