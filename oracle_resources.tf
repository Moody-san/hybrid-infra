data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

variable "servers" {
  default = [
    {
      display_name = "oracle_master "
      cpu          = 2
      memory = 8
    },
    {
      display_name = "oracle_worker1"
      cpu          = 1
      memory = 8
    },
    {
      display_name = "oracle_worker2"
      cpu          = 1
      memory = 8
    }
  ]
}
module "network" {
  source         = "./Modules/Oracle_Module/network"
  compartment_id = var.compartment_id
}

module "server" {
  source         = "./Modules/Oracle_Module/compute"
  for_each       = { for server in var.servers : server.display_name => server }
  cpu            = each.value.cpu
  memory = each.value.memory
  AD             = data.oci_identity_availability_domains.ads.availability_domains[2]["name"] // for ad=3
  server_name    = each.value.display_name
  subnet_id      = module.network.subnet_id
  image_id       = var.image_id
  ssh_key        = var.ssh_key
  compartment_id = var.compartment_id
  depends_on     = [module.network]
}


output "oracle_server_public_ip" {
  value = { for k, v in module.server : k => v.compute_public_ip }
}