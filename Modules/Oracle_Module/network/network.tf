resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_block     = var.cidr_ip_block
  display_name   = var.vcn_name
  dns_label      = var.vcn_name
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  display_name   = var.internet_gateway_name
  vcn_id         = oci_core_vcn.vcn.id
}

resource "oci_core_route_table" "prt" {
  compartment_id = var.compartment_id
  display_name   = var.route_table_name
  vcn_id         = oci_core_vcn.vcn.id

  route_rules {
    destination       = var.destination_ip
    network_entity_id = oci_core_internet_gateway.igw.id
  }
  route_rules {
    destination       = var.azure_ipcidr
    network_entity_id = oci_core_drg.drg.id
  }
}

resource "oci_core_subnet" "subnet" {
  availability_domain        = var.AD
  compartment_id             = var.compartment_id
  display_name               = var.subnet_name
  vcn_id                     = oci_core_vcn.vcn.id
  cidr_block                 = var.applicationsubnet_ip
  route_table_id             = oci_core_route_table.prt.id
  security_list_ids          = [oci_core_security_list.securitylist.id]
  prohibit_public_ip_on_vnic = false
  dns_label                  = var.subnet_name
  dhcp_options_id            = oci_core_dhcp_options.test_dhcp_options.id
}

resource "oci_core_dhcp_options" "test_dhcp_options" {
  #Required
  compartment_id = var.compartment_id
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type                = "SearchDomain"
    search_domain_names = ["${var.subnet_name}.${var.vcn_name}.oraclevcn.com"]
  }

  vcn_id       = oci_core_vcn.vcn.id
  display_name = "customdhcp"
}

resource "oci_core_security_list" "securitylist" {

  display_name   = var.security_list_name
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id

  egress_security_rules {
    protocol    = var.egress_rules.protocol
    destination = var.egress_rules.destination
  }

  ingress_security_rules {
    protocol = var.ingress_rules.protocol
    source   = var.ingress_rules.source

  }
}

#for vpn

# create and attach drg
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_id
}

resource "oci_core_drg_attachment" "vcndrgattachment" {
  drg_id = oci_core_drg.drg.id
  network_details {
    id   = oci_core_vcn.vcn.id
    type = "VCN"
  }
}