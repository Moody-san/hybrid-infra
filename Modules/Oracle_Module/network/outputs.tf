output "ociprivatesubnet_id" {
  value = oci_core_subnet.privatesubnet.id
}

output "ocipublicsubnet_id" {
  value = oci_core_subnet.pubsubnet.id
}

output "ocidrgid" {
  value = oci_core_drg.drg.id
}