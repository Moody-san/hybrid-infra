#Network variables
variable "cidr_ip_block" {
  default = "10.0.0.0/16"
}
variable "vcn_name" {
  default = "vcn"
}
variable "internet_gateway_name" {
  default = "igw"
}
variable "route_table_name" {
  default = "prt"
}
variable "destination_ip" {
  default = "0.0.0.0/0"
}
variable "subnet_name" {
  default = "subnet"
}
variable "subnet_ip" {
  default = "10.0.1.0/24"
}
variable "security_list_name" {
  default = "sl"
}
variable "egress_rules" {
  default = {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}
variable "tcp_ingress_rules" {
  default = {
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}
variable "ingress_ports" {
  default = [22, 80, 443]
}
variable "icmp_ingress_rules" {
  default = {
    protocol = "1"
    source   = "0.0.0.0/0"
    type     = 8
  }
}
