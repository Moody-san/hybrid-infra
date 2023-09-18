resource "oci_core_cpe" "cpe" {
  compartment_id = var.ocicompartment_id
  ip_address     = "AWS_VGW_PUBLIC_IP"  # Replace this with one of the AWS VGW public IPs
}

# create ipsec con
resource "oci_core_ipsec" "ip_sec_connection" {
  compartment_id = var.ocicompartment_id
  cpe_id         = oci_core_cpe.cpe.id
  drg_id         = var.drgid
  static_routes  = ["0.0.0.0/0"] # temporary will edit to bgp from script
}

data "oci_core_ipsec_connection_tunnels" "created_ip_sec_connection_tunnels" {
  ipsec_id = oci_core_ipsec.ip_sec_connection.id
}

data "oci_core_ipsec_config" "ip_sec_connection_device_config" {
  ipsec_id   = oci_core_ipsec.ip_sec_connection.id
  depends_on = [null_resource.ip_sec_connection_tunnel_configuration]
}

resource "null_resource" "compile_script" {
  triggers = {
    value = "run only once"
  }
  provisioner "local-exec" {
    command     = "tsc script.ts"
    working_dir = "./oci_vpn_advance_config"
  }
}

resource "null_resource" "ip_sec_connection_tunnel_configuration" {
  triggers = {
    value  = "run only once"
  }
  depends_on = [oci_core_ipsec.ip_sec_connection, null_resource.compile_script]
  provisioner "local-exec" {
    working_dir = "./oci_vpn_advance_config"
    command     = "npm run script -- ${oci_core_ipsec.ip_sec_connection.id} ${data.oci_core_ipsec_connection_tunnels.created_ip_sec_connection_tunnels.ip_sec_connection_tunnels[0].id} ${local.tunnel_bgp_ips[0].oip}${local.tunnel_bgp_ips[0].mask} ${local.tunnel_bgp_ips[0].cip}${local.tunnel_bgp_ips[0].mask}"
  }
  provisioner "local-exec" {
    working_dir = "./oci_vpn_advance_config"
    command     = "npm run script -- ${oci_core_ipsec.ip_sec_connection.id} ${data.oci_core_ipsec_connection_tunnels.created_ip_sec_connection_tunnels.ip_sec_connection_tunnels[1].id} ${local.tunnel_bgp_ips[1].oip}${local.tunnel_bgp_ips[1].mask} ${local.tunnel_bgp_ips[1].cip}${local.tunnel_bgp_ips[1].mask}"
  }
}

output "drgid" {
  value = var.drgid
}

data "oci_core_ipsec_connection_tunnels" "created_ip_sec_connection_tunnels" {
  ipsec_id = oci_core_ipsec.ip_sec_connection.id
}
output "first_tunnel_details" {
  value = data.oci_core_ipsec_connection_tunnels.created_ip_sec_connection_tunnels.ip_sec_connection_tunnels[0]
}
