resource "oci_core_instance" "server" {
  availability_domain = var.AD
  compartment_id      = var.compartment_id
  shape               = var.vm_shape


  create_vnic_details {
    assign_private_dns_record = true
    display_name              = var.server_name
    hostname_label            = var.server_name
    subnet_id                 = var.subnet_id
    skip_source_dest_check    = true
    assign_public_ip          = var.assign_public_ip
  }
  source_details {
    source_type             = "image"
    source_id               = var.image_id
    boot_volume_size_in_gbs = var.boot_volume
  }
  shape_config {
    ocpus         = var.cpu
    memory_in_gbs = var.memory
  }
  
  metadata = {
    ssh_authorized_keys = file(var.ssh_key)
  }

  agent_config {
    is_management_disabled = false
    is_monitoring_disabled = false
    plugins_config {
      desired_state = "DISABLED"
      name = "Bastion"
    }
  }
  
}

