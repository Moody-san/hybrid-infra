data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

variable "servers" {
  default = ["1","2","3","4"]
}

module "network" {
  source = "./Modules/Oracle_Module/network"
  compartment_id = var.compartment_id
}

module "server" {
  source         = "./Modules/Oracle_Module/compute"
  for_each       = toset(var.servers)
  AD             = data.oci_identity_availability_domains.ads.availability_domains[2]["name"] // for ad=3
  server_name    = "server${each.value}"
  subnet_id      = module.network.subnet_id
  image_id = var.image_id
  ssh_key = var.ssh_key
  compartment_id = var.compartment_id
  depends_on = [ module.network ]
}


output "server_public_ip" {
  value = { for k, v in module.server : k => v.compute_public_ip }
}