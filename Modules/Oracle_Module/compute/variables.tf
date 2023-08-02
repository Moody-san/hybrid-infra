
#Compute Variables

variable "source_type" {
  default = "image"
}

variable "image_shape" {
  default = "VM.Standard.A1.Flex"
}


variable "boot_volume" {
  default = "50"
}

variable "cpu" {
  default = "1"
}

variable "memory" {
  default = "6"
}

variable "server_name" {
  default = "server"
}


variable "ssh_key" {
}

variable "AD" {
}

variable "compartment_id" {
}

variable "subnet_id" {
}

variable "image_id" {
}
