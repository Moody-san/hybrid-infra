resource "oci_load_balancer_load_balancer" "k8s_load_balancer" {
  #Required
  compartment_id = var.compartment_ocid
  display_name   = "k8sloadbalancer"
  shape          = "flexible"
  subnet_ids     = [var.subnet_id]
  #Optional
  is_private = true
  shape_details {
    #Required
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_backend_set" "k8s_backend_set" {
  #Required
  health_checker {
    #Required
    protocol = "TCP"
    #Optional
    port = 6443
  }
  load_balancer_id = oci_load_balancer_load_balancer.k8s_load_balancer.id
  name             = "k8s_masternodebackend_set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_listener" "k8s_listener" {
  #Required
  default_backend_set_name = oci_load_balancer_backend_set.k8s_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.k8s_load_balancer.id
  name                     = "k8s_loadbalancer_listener"
  port                     = 6443
  protocol                 = "TCP"
}

resource "oci_load_balancer_backend" "k8s_backends" {
  count = length(local.instances)
  #Required
  backendset_name  = oci_load_balancer_backend_set.k8s_backend_set.name
  ip_address       = local.instances[count.index].server_ip
  load_balancer_id = oci_load_balancer_load_balancer.k8s_load_balancer.id
  port             = 6443
}