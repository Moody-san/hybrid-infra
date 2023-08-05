#to avoid circular dependency created drg in oraclenetwork

# create cpe add azure vpn gateway public ip


resource "oci_core_cpe" "azurecpe" {
  compartment_id = var.ocicompartment_id
  ip_address     = data.azurerm_public_ip.gwip.ip_address
}

# create ipsec con
resource "oci_core_ipsec" "azure_ip_sec_connection" {
  compartment_id = var.ocicompartment_id
  cpe_id         = oci_core_cpe.azurecpe.id
  drg_id         = var.drgid
  static_routes  = ["0.0.0.0/0"] # temporary
}

data "oci_core_ipsec_connection_tunnels" "created_ip_sec_connection_tunnels" {
  ipsec_id = oci_core_ipsec.azure_ip_sec_connection.id
}


data "oci_core_ipsec_config" "ip_sec_connection_device_config" {
  ipsec_id   = oci_core_ipsec.azure_ip_sec_connection.id
  depends_on = [oci_core_ipsec_connection_tunnel_management.azure_ip_sec_connection_tunnel]
}

resource "oci_core_ipsec_connection_tunnel_management" "azure_ip_sec_connection_tunnel" {

  for_each  = { for tunnel in local.tunnel_bgp_ips : tunnel.index => tunnel }
  ipsec_id  = oci_core_ipsec.azure_ip_sec_connection.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.created_ip_sec_connection_tunnels.ip_sec_connection_tunnels[each.value.index].id
  routing   = "BGP"

  bgp_session_info {
    customer_bgp_asn      = 65515
    customer_interface_ip = "${each.value.cip}${each.value.mask}"
    oracle_interface_ip   = "${each.value.oip}${each.value.mask}"
  }
  ike_version = "V2"
}


output "drgid" {
  value = var.drgid
}

#need to manually adjust advance config