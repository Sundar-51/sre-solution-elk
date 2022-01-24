#Public Subnets
resource "aws_subnet" "public_subnets" {
  cidr_block              = var.public_subnet_cidr[count.index]
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = var.map_public_ip_on_launch[0]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  count=var.public_subnet_count
  tags = {
    Name = "public-subnet${count.index+1}"
  }
}
#Private Subnets
resource "aws_subnet" "private_subnets" {
  cidr_block              = var.private_subnet_cidr[count.index]
  vpc_id                  = aws_vpc.vpc[0].id
  map_public_ip_on_launch = var.map_public_ip_on_launch[1]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  count=var.private_subnet_count
  tags = {
    Name = "private-subnet${count.index+1}"
  }
}
/*resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.public_subnet1_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags= {
    Name="public-subnet1"
  }
}
#PUBLIC SUBNET 2
resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.public_subnet2_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags= {
    Name="public-subnet2"
  }
}

#PRIVATE SUBNET 1
resource "aws_subnet" "private_subnet1" {
  cidr_block              = var.private_subnet1_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_private_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags= {
    Name="private-subnet1"
  }
}
#PRIVATE SUBNET 2
resource "aws_subnet" "private_subnet2" {
  cidr_block              = var.private_subnet2_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_private_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags= {
    Name="private-subnet2"
  }
}*/