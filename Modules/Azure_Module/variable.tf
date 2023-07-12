variable "region" {
  default = "ind-central"
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

variable "ports" {
  default = ["22","443","80"]
}
