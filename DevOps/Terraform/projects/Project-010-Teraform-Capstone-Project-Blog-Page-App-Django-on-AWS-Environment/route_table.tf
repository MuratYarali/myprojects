resource "aws_route_table" "public" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "tf-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf-private-rt"
  }
}
