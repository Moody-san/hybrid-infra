data "oci_identity_availability_domains" "ads" {
  compartment_id = var.oci_compartment_id
}

module "oraclenetwork" {
  providers = {
    oci = oci.oci_us
  }
  source         = "./Modules/Oracle_Module/network"
  compartment_id = var.oci_compartment_id
  AD             = data.oci_identity_availability_domains.ads.availability_domains[2]["name"]
}

module "oracleservers" {
  providers = {
    oci = oci.oci_us
  }
  source           = "./Modules/Oracle_Module/compute"
  for_each         = { for server in local.oracleservers : server.display_name => server }
  cpu              = each.value.cpu
  memory           = each.value.memory
  AD               = data.oci_identity_availability_domains.ads.availability_domains[2]["name"] // for ad=3
  server_name      = each.value.display_name
  subnet_id        = each.value.subnet_id
  ssh_key          = var.ssh_key
  compartment_id   = var.oci_compartment_id
  image_id         = each.value.image
  boot_volume      = each.value.boot_volume
  assign_public_ip = each.value.assign_public_ip
  depends_on       = [module.oraclenetwork]
}

output "oracle_servers" {
  value = module.oracleservers
}


module "oracleloadbalancer" {
  providers = {
    oci = oci.oci_us
  }
  source           = "./Modules/Oracle_Module/loadbalancer"
  subnet_id        = module.oraclenetwork.ocipublicsubnet_id
  compartment_ocid = var.oci_compartment_id
  depends_on       = [module.oracleservers]
  oracleservers    = module.oracleservers
}


module "k8soracleloadbalancer" {
  providers = {
    oci = oci.oci_us
  }
  source           = "./Modules/Oracle_Module/k8sloadbalancer"
  subnet_id        = module.oraclenetwork.ociprivatesubnet_id
  compartment_ocid = var.oci_compartment_id
  depends_on       = [module.oracleservers]
  oracleservers    = module.oracleservers
}