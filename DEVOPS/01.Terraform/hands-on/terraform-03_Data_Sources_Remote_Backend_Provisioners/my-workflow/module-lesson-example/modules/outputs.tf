output "my-terraform-user" {
  value = aws_iam_user.my_new_user.name
}