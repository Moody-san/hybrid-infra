data "template_file" "k8sinventory" {
  template = file(var.k8stemplatepath)
  vars = {
    nodes         = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*worker.*|.*master.*", server.display_name), server.display_name) ? "${server.display_name} ansible_host=${server.public_ip} ansible_connection=ssh ansible_user=ubuntu\n" : ""])])}"
    master        = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*master$", server.display_name), server.display_name) ? server.display_name : ""])])}"
    workers       = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*worker.*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
    extra_masters = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*master[1-9].*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
  }
}

resource "local_file" "k8sinventory_file" {
  content  = data.template_file.k8sinventory.rendered
  filename = var.k8sinventorypath
}