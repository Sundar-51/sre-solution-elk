resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.igw]
} 
resource "aws_nat_gateway" "ngw1" {
  allocation_id=aws_eip.nat1.id
  subnet_id= aws_subnet.public_subnets[0].id
  tags = {
    Name = "NAT-gw1"
  }
}

/*resource "aws_eip" "nat1" {

  depends_on = [aws_internet_gateway.igw]
} 
resource "aws_nat_gateway" "ngw1" {
  allocation_id=aws_eip.nat1.id
  subnet_id= aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT-gw1"
  }
}*/
