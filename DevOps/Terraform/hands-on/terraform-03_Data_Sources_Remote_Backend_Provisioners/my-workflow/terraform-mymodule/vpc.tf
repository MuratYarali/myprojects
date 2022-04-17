provider "aws" {
    region = "us-east-1"
}

//virtual private cloud (VPC)
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/16"
  tags = {
      name= "terraform_aws_vpc"
  }
}
