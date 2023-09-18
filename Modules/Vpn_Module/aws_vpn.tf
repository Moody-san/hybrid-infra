resource "aws_vpn_gateway" "vpngw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "my-vpn-gateway"
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 31898 
  ip_address =  var.oci_vpn_public_ip# Replace with your OCI VPN public IP
  type       = "ipsec.1"

  tags = {
    Name = "my-customer-gateway"
  }
}

resource "aws_vpn_connection" "vpnconn" {
  vpn_gateway_id      = aws_vpn_gateway.vpngw.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = false
}
# resource "aws_vpn_gateway_route_propagation" "route_propagation" {
#   count          = length(var.route_propagation_route_table_ids)
#   vpn_gateway_id = join("", aws_vpn_gateway.virtual_private_gateways.*.id)
#   route_table_id = element(var.route_propagation_route_table_ids, count.index)
# }

# resource "aws_vpn_connection_route" "vpn_connection_route" {
#   count                  = var.virtual_private_gateways_availability_zone == null ? 0 : length(var.vpn_connection_route_destination_cidr_block)
#   destination_cidr_block = element(var.vpn_connection_route_destination_cidr_block, count.index)
#   vpn_connection_id      = aws_vpn_connection.vpnconn.id
# }