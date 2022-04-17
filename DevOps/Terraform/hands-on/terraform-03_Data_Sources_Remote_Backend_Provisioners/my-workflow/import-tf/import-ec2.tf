provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "basic" {
  ami = ami-0c02fb55956c7d316
  instance_type = "t2.micro"
  key_name = "firstkey"
  vpc_security_group_ids = ["vpc-0036a63abf476f6a5"]
  subnet_id = "subnet-0adc091bb634bc298"
  tags = {
    Name = "learn-tf-import"
  }
}