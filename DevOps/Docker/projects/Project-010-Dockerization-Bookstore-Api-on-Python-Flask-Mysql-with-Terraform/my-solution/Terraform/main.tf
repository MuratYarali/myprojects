resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.main_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}

resource "aws_instance" "my-ec2" {
  ami                    = data.aws_ami.my-ami.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  user_data              = file("./configuration.sh")
  tags = {
    "Name" = "Web Server of Bookstore"
  }
}