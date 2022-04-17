module "tf-vpc" {
  source = "../modules"
  env    = "PROD"
}

output "vpc_cidr_block" {
  value = module.tf-vpc.vpc_cidr
}