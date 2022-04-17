resource "aws_subnet" "public" {
  count             = length(var.subnet_cidr_public)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.subnet_cidr_public[count.index]
  availability_zone = var.AZ[count.index]
}

resource "aws_subnet" "private" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.AZ[count.index]
}