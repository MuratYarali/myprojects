resource "aws_instance" "my_instance" {
  ami = "ami-0c02fb55956c7d316" #if you want you can data for ami 
  instance_type = "t2.micro"
  key_name = "firstkey" #if you want you can create variable for key-name
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]
  subnet_id = "${aws_subnet.my_sb.id}"
  associate_public_ip_address = true

tags = {
  Name = "web"
}

}
