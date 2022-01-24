resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.vpc[0].id
  route {
    cidr_block = var.all_cidrs
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }
  tags= {
    Name="rtb2"
  }
}
resource "aws_route_table_association" "rta-private_subnet" {
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb2.id
  count = var.private_subnet_count
}

/*resource "aws_route_table" "rtb2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }
  tags= {
    Name="rtb2"
  }
}
resource "aws_route_table_association" "rta-private_subnet1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rtb2.id
}

resource "aws_route_table_association" "rta-private_subnet2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rtb2.id
}
*/