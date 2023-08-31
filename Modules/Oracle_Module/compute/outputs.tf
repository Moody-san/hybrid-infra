output server_details {
  value = {
    name=join("",[oci_core_instance.server.hostname_label])
    all_details= join("",[oci_core_instance.server.hostname_label," ansible_host=", oci_core_instance.server.public_ip=="" ? oci_core_instance.server.private_ip: oci_core_instance.server.public_ip," ansible_user=ubuntu"])
    is_oracle_master = contains(regexall(".*master$", oci_core_instance.server.hostname_label), oci_core_instance.server.hostname_label)
    is_oracle_worker = contains(regexall(".*worker.*", oci_core_instance.server.hostname_label), oci_core_instance.server.hostname_label)
    is_oracle_db = contains(regexall(".*db.*", oci_core_instance.server.hostname_label), oci_core_instance.server.hostname_label)
    is_oracle_extramaster = contains(regexall(".*master[1-9].*", oci_core_instance.server.hostname_label), oci_core_instance.server.hostname_label)
    is_oracle_bastion = contains(regexall(".*bastion.*", oci_core_instance.server.hostname_label), oci_core_instance.server.hostname_label)
    public_ip = oci_core_instance.server.public_ip
    private_ip = oci_core_instance.server.private_ip
  }
}
