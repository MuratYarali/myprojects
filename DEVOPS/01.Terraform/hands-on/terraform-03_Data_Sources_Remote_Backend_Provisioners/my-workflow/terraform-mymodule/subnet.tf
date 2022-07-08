resource "aws_subnet" "my_sb" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "172.31.1.0/24"
  tags = {
    "Name" = "public"
  }
}