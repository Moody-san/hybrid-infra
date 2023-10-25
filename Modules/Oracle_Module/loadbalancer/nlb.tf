
resource "oci_network_load_balancer_network_load_balancer" "nlb_load_balancer" {
  compartment_id = var.compartment_ocid
  display_name   = "nlb"
  subnet_id      = var.subnet_id

  is_private                     = false
  is_preserve_source_destination = false
}

resource "oci_network_load_balancer_listener" "nlb_tcp_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_backend_set.name
  name                     = "nlb_tcp_listener"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_load_balancer.id
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "nlb_backend_set" {
  health_checker {
    protocol = "TCP"
  }

  name                     = "nlb_backend_set"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_load_balancer.id
  policy                   = "FIVE_TUPLE"
  is_preserve_source       = true
}


resource "oci_network_load_balancer_backend" "nlb_backend" {
  count = length(local.instances)
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_backend_set.name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_load_balancer.id
  name                     = local.instances[count.index].server_name
  port                     = 31736
  target_id                = local.instances[count.index].server_id
}
