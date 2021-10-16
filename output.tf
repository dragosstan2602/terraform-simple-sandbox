output "vpc_id" {
  value = aws_vpc.myVPC.id
}

output "vpc_cidr_block" {
  value = aws_vpc.myVPC.cidr_block
}

# output "subnets" {
#   value = aws_subnet.private_subnets
# }

output "subnet_01_id" {
  value = aws_subnet.private_subnets[0].id
}

output "subnet_02_id" {
  value = aws_subnet.private_subnets[1].id
}

output "subnet_03_id" {
  value = aws_subnet.private_subnets[2].id
}

output "subnet_01_cidr" {
  value = aws_subnet.private_subnets[0].cidr_block
}

output "subnet_02_cidr" {
  value = aws_subnet.private_subnets[1].cidr_block
}

output "subnet_03_cidr" {
  value = aws_subnet.private_subnets[2].cidr_block
}

output "private_rt_id" {
  value = aws_route_table.private_rt.id
}

output "public_rt_id" {
  value = aws_route_table.public_rt.id
}

output "vpn_gw_id" {
  value = aws_vpn_gateway.vpn_gw.id
}

