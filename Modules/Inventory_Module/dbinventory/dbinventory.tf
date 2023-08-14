data "template_file" "dbinventory" {
  template = file(var.dbtemplatepath)
  vars = {
    oracledbs = "${join("", [for server in var.oracleservers : join("", [contains(regexall(".*db.*", server.display_name), server.display_name) ? "${server.display_name} ansible_host=${server.public_ip} ansible_connection=ssh ansible_user=ubuntu\n" : ""])])}"
    azuredbs = "${join("", [for server in var.azureservers : join("", [contains(regexall(".*db.*", server.display_name), server.display_name) ? "${server.display_name} ansible_host=${server.public_ip} ansible_connection=ssh ansible_user=ubuntu\n" : ""])])}"
    db1 = "${join("", [for server in var.azureservers : join("", [contains(regexall(".*db.*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
    db2 = "${join("", [for server in var.oracleservers : join("", [contains(regexall(".*db.*", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
    oraclemaster = "${join("", [for server in var.oracleservers : join("", [contains(regexall(".*master$", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}"
    azuremaster = "${join("", [for server in var.azureservers : join("", [contains(regexall(".*master$", server.display_name), server.display_name) ? "${server.display_name}\n" : ""])])}" 
  }
}

resource "local_file" "dbinventory_file" {
  content  = data.template_file.dbinventory.rendered
  filename = var.dbinventorypath
}