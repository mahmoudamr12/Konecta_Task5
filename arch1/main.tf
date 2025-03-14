provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "arch1_vpc" {
  cidr_block = var.vpc_cidr
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.arch1_vpc.id
  cidr_block              = var.public_subnet_cidr
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.arch1_vpc.id
  cidr_block = var.private_subnet_cidr
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.arch1_vpc.id
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.arch1_vpc.id
}



resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}



resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "My-NAT-Gateway"
  }

  lifecycle {
    prevent_destroy = true
  }
}




resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.arch1_vpc.id
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}



resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}



resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = aws_key_pair.generated_key.key_name
}
