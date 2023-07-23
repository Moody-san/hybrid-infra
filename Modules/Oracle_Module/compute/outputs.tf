output "compute_public_ip" {
  value = oci_core_instance.server.public_ip
}

output "compute_private_ip" {
  value = oci_core_instance.server.private_ip
}