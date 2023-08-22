output "public_ip" {
  value = oci_core_instance.server.public_ip
}

output "display_name" {
  value = oci_core_instance.server.hostname_label
}


output "private_ip" {
  value = oci_core_instance.server.private_ip
}


