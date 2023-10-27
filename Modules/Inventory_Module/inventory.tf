resource "null_resource" "add_bastion_fingerprint_to_known_hosts" {
  count = length(local.allservers.ocibastionpubip)
  triggers = {
    always_run = timestamp()
  }

 provisioner "local-exec" {
    command = "if [ -f ~/.ssh/known_hosts ]; then rm -f ~/.ssh/known_hosts*; fi"
  }

  provisioner "local-exec" {
    command = "if [ -f ~/tmp.txt ]; then rm -f ~/tmp.txt; fi"
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -t rsa ${local.allservers.ocibastionpubip[0]} >> ~/.ssh/known_hosts 2>> ~/error.txt || echo ok" 
  }

  provisioner "local-exec" {
    command = "cat ~/.ssh/known_hosts >> ~/tmp.txt 2>> ~/error.txt"
  }
}

resource "null_resource" "add_oracleservers_fingerprint_to_tmp" {
  count = length(local.allservers.oracleips)
  triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.add_bastion_fingerprint_to_known_hosts]

  provisioner "local-exec" {
    command = "ssh -i ~/.ssh/id_rsa ${local.allservers.ocibastionpubip[0]} ssh-keyscan -t rsa ${local.allservers.oracleips[count.index]} >> ~/tmp.txt 2>> ~/error.txt || echo ok"
  }
}

resource "null_resource" "add_azureservers_fingerprint_to_tmp" {
  count = length(local.allservers.azureips)
  triggers = {
    always_run = timestamp() 
  }
  depends_on = [null_resource.add_bastion_fingerprint_to_known_hosts]

  provisioner "local-exec" {
    command = "ssh -i ~/.ssh/id_rsa ${local.allservers.ocibastionpubip[0]} ssh-keyscan -t rsa ${local.allservers.azureips[count.index]} >> ~/tmp.txt 2>> ~/error.txt || echo ok"
  }
}


resource "null_resource" "add_servers_to_known_hosts" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.add_azureservers_fingerprint_to_tmp, null_resource.add_oracleservers_fingerprint_to_tmp]

  provisioner "local-exec" {
    command = "if [ -f ~/.ssh/known_hosts ]; then rm -f ~/.ssh/known_hosts*; fi"
  }

  provisioner "local-exec" {
    command = "if [ -f ~/tmp.txt ]; then cat ~/tmp.txt >> ~/.ssh/known_hosts; fi"
  }

  provisioner "local-exec" {
    command = "if [ -f ~/tmp.txt ]; then rm -f ~/tmp.txt; fi"
  }
}


#oracle inventory
resource "local_file" "oraclek8sinventory_file" {
  content = templatefile(var.oraclek8stemplatepath,local.allservers )
  filename = var.oraclek8sinventorypath
}

#db inventory
resource "local_file" "dbinventory_file" {
  content  = templatefile(var.dbtemplatepath,local.allservers )
  filename = var.dbinventorypath
}

# azure inventory
resource "local_file" "azurek8sinventory_file" {
  content = templatefile(var.azurek8stemplatepath,local.allservers )
  filename = var.azurek8sinventorypath
}
