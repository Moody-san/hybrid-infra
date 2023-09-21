resource "random_string" "psk" {
  length  = 16
  special = false
}
resource "aws_vpn_gateway" "gateway" {
  vpc_id            = module.aws_server.vpc_id
  tags = merge(
    { "Name" = "vpn-gateway" },
  )
}

resource "aws_customer_gateway" "main" {
  bgp_asn    =  31898
  ip_address = "1.1.1.1"
  type       = "ipsec.1"

  tags = {
    Name = "complete-vpn-gateway"
  }
}
module "oci-aws-vpn" {
    providers = {
        aws = aws.us
        oci = oci.oci_us
    }
    source            = "./Modules/oci_aws_vpn_module"
    drgid = module.oraclenetwork.ocidrgid
    ocicompartment_id = var.oci_compartment_id
    vpn_gateway_id = aws_vpn_gateway.gateway.id
    customer_gateway_id = aws_customer_gateway.main.id
    tunnel1_preshared_key = random_string.psk.result
    tunnel2_preshared_key = random_string.psk.result
    depends_on        = [module.oraclenetwork, module.aws_server]
}


module "aws_server" {
    source = "./Modules/Aws_Module"
    providers = {
        aws = aws.us
    }

}



resource "null_resource" "update_aws_customer_gateway" {
  provisioner "local-exec" {
    command = "aws ec2 modify-customer-gateway --customer-gateway-id ${aws_customer_gateway.main.id} --ip-address ${self.triggers["oci_vpn_tunnel1_ip"]}"
  }

  triggers = {
    oci_vpn_tunnel1_ip = module.oci-aws-vpn.first_tunnel_oci_ip_address
  }
}