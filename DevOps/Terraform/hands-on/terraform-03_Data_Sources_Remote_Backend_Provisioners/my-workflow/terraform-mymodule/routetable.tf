resource "aws_route_table" "my_rt" {
  vpc_id = "${aws_vpc.my_vpc.id }"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_gw.id}"
  }

  tags = {
    Name = "public"
  }

}
resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.my_sb.id}"
  route_table_id = "${aws_route_table.my_rt.id}"
}
