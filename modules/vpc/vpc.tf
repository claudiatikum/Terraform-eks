#creating VPC named "network" where name is used in the tfcode only
resource "aws_vpc" "network" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = merge(
    local.cluster_tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags: eks adds the kubernetes.io/cluster/${cluster_name} tag
      tags,
    ]
  }
}

#creating Internet gateway so that through public subnets we will have access to internet and vice-versa
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = var.name
  }
}

#creating   elastic_IP address which wil be added to NAT gateway so that through NAT gateway private resources can access intrnet
resource "aws_eip" "nat_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

#creating NAT gateway so that worker nodes running in private subnet will be able to access internet and not vice-versa
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public[var.availability_zones[0]].id

  tags = {
    Name = var.name
  }
}

#creating route table to public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = "${var.name}-public"
  }
}

#creating route table to add the internet gateway
resource "aws_route" "internet-gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

#creating route table for private subnet
resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.network.default_route_table_id

  tags = {
    Name = "${var.name}-private"
  }
}

#creating route for nat-gateway.
resource "aws_route" "nat-gateway" {
  route_table_id         = aws_default_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
