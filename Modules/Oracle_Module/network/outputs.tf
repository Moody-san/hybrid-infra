output "subnet_id" {
  value = oci_core_subnet.subnet.id
}

output "drgid" {
  value = oci_core_drg.drg.id
}