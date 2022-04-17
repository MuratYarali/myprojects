output "instance_public_ip" {
  value = aws_instance.tf-ec2.*.public_ip
}