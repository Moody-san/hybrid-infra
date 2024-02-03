output "public_ip" {
  value = oci_network_load_balancer_network_load_balancer.nlb_load_balancer.ip_addresses[0].ip_address
}