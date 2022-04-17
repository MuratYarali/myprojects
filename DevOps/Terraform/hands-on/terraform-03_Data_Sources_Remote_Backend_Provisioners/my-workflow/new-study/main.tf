terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "kitten-ec2" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = "firstkey1"
  user_data = file("./script.sh")
  security_groups = [ "tf-ec2" ]
  tags = {
    Name = "kitten-website"
  }
}

resource "aws_security_group" "web-sg" {
  name = "tf-ec2"
  description = "allow ssh and http"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "ec2-public-ip" {
  value = aws_instance.kitten-ec2.public_ip
}