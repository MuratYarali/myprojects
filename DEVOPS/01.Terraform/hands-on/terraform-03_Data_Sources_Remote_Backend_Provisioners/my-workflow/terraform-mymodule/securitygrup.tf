resource "aws_security_group" "my_sg" {
  name = "public"
  description = "allow to the public subnet to the internet"

  vpc_id = "${aws_vpc.my_vpc.id}"
ingress {
    from_port = 80
    to_port = 80 
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
}
ingress {
    from_port = 22
    to_port = 22 
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
}
egress {
    from_port ="443"
    to_port ="443"
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
}
egress {
    from_port ="80"
    to_port ="80"
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
    
}
}