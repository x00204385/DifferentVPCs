resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "wordpress-VPC"
  }
}

resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[0]
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zones[0]

  tags = {
    Name    = "public-subnet-1a"
    Purpose = "wordpress-POC"
  }
}

resource "aws_subnet" "private-subnet-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_blocks[0]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zones[0]

  tags = {
    Name    = "private-subnet-1a"
    Purpose = "wordpress-POC"
  }
}

resource "aws_subnet" "public-subnet-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[1]
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zones[1]

  tags = {
    Name    = "public-subnet-1b"
    Purpose = "wordpress-POC"
  }
}

resource "aws_subnet" "private-subnet-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_blocks[1]
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zones[1]

  tags = {
    Name    = "private-subnet-1b"
    Purpose = "wordpress-POC"
  }
}
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "internet-gw"
    Purpose = "wordpress-POC"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags = {
    Purpose = "wordpress-POC"
  }
}

resource "aws_route_table_association" "public-rta-1a" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rta-1b" {
  subnet_id      = aws_subnet.public-subnet-1b.id
  route_table_id = aws_route_table.public-rt.id
}
