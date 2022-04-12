resource "aws_security_group" "webserverSG" {
  name        = "Web_Server_Security_Group"
  description = "Accept HTTP and SSH Traffic"
  vpc_id      = var.vpc_id # lookup(var.awsprops, "vps_id")

  //To Allow Port 22 SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //To Allow Port 80 HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //From Allow TLS

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserverSG"
  }
}

data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "Roman_Numerals" {
  ami                    = data.aws_ami.tf_ami.id
  instance_type          = var.instance_type
  key_name               = var.keyname
  vpc_security_group_ids = [aws_security_group.webserverSG.id]
  user_data              = file("./post_configuration.sh")
  tags = {
    "Name" = "Roman_Numerals"
  }
}