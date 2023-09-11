resource "aws_vpn_gateway" "vpngw" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name = "my-vpn-gateway"
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 31898# Use appropriate ASN value
  ip_address = "OCI_VPN_PUBLIC_IP" # Replace with your OCI VPN public IP
  type       = "ipsec.1"

  tags = {
    Name = "my-customer-gateway"
  }
}

resource "aws_vpn_connection" "vpnconn" {
  vpn_gateway_id      = aws_vpn_gateway.vpngw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = true
}
