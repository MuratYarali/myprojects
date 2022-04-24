output "my_ec2_public_ip" {
  value = aws_instance.my-ec2.public_ip
}