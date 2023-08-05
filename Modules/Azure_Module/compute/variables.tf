variable "pub_ip_type" {
  default = "Dynamic"
}

variable "pvt_ip_type" {
  default = "Dynamic"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "prefix" {
  default = "azure"
}

variable "username" {
  default = "ubuntu"
}

variable "hostname" {
  default = "server"
}

variable "source_image_reference" {
  default = {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    version   = "latest"
  }
}
variable "os_disk" {
  default = {
    name    = "myosdisk"
    caching = "ReadWrite"
  }
}

variable "diskstoragetype" {
  default = "Standard_LRS"
}

variable "diskstoragegbs" {
  default = "32"
}

variable "location" {

}

variable "rgname" {

}

variable "subnet_id" {

}

variable "imagetype" {

}

variable "ssh_key" {

}
