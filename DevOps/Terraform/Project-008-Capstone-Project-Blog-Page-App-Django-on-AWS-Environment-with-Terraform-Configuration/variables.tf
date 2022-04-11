variable "key-name" {
  type        = string
  description = "The AWS key pair to use for resources."
}

variable "ami" {
  type = map(string)
  #   type = "map"
  description = "A map of AMIs."
  default     = {}
}

variable "instance-type" {
  type        = string
  description = "The instance type."
  default     = "t2.micro"
}

variable "region" {
  type        = string
  description = "The AWS region."
}

variable "AZ" {
  description = "The AWS region."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_public" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "subnet_cidr_private" {
  description = "Subnet CIDRs for private subnets (length must match configured availability_zones)"
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}