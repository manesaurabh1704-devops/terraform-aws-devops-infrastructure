resource "aws_subnet" "public_subnet" {

  vpc_id = var.vpc_id
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }

}

resource "aws_subnet" "public_subnet_2" {

  vpc_id = var.vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }

}
resource "aws_subnet" "private_subnet" {

  vpc_id = var.vpc_id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet"
  }

}

resource "aws_eip" "nat_eip" {

  domain = "vpc"

}

resource "aws_nat_gateway" "nat_gateway" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }

}

resource "aws_route_table" "public_rt" {

  vpc_id = var.vpc_id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id

  }

}

resource "aws_route_table" "private_rt" {

  vpc_id = var.vpc_id

  route {

    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id

  }

}

resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}

resource "aws_route_table_association" "private_assoc" {

  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id

}
