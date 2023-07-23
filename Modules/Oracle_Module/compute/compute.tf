data "template_file" "cloud-config" {
  template = <<YAML
#cloud-config
runcmd:
  - sudo apt update -y
  - sudo DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
  - sudo DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade
  - sudo apt-get autoremove -y
  - sudo apt-get clean
  - sudo apt-get autoclean
  - sudo shutdown -r now 
YAML
}

resource "oci_core_instance" "server" {
  availability_domain = var.AD
  compartment_id      = var.compartment_id
  shape               = var.image_shape


  create_vnic_details {
    private_ip = var.private_ip
    assign_private_dns_record = true
    display_name        = var.server_name
    hostname_label = var.server_name
    subnet_id        = var.subnet_id
    skip_source_dest_check = true
    assign_public_ip = true
  }
  source_details {
    source_type             = var.source_type
    source_id               = var.image_id
    boot_volume_size_in_gbs = var.boot_volume
  }
  shape_config {
    ocpus         = var.cpu
    memory_in_gbs = var.memory
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_key)
    user_data = "${base64encode(data.template_file.cloud-config.rendered)}"
  }
}

