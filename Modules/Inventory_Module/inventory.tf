data "template_file" "inventory" {
  template = file(var.templatepath)
  vars = {
    nodes         = "${join("\n", [for server in var.cloudservers : join("", [server.display_name, " ansible_host=", server.public_ip, " ansible_connection=ssh ansible_user=ubuntu"])])}"
    master        = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*master$", server.display_name), server.display_name) ? server.display_name : ""])])}"
    workers       = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*worker.*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
    extra_masters = "${join("", [for server in var.cloudservers : join("", [contains(regexall(".*master[1-9].*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
  }
}

resource "local_file" "inventory_file" {
  content  = data.template_file.inventory.rendered
  filename = var.inventorypath
}