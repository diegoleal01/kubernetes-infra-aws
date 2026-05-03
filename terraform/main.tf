module "vpc" {
  source = "../../terraform-aws-vpc/"

  project_name           = var.project_name
  vpc_cidr_block         = var.vpc_cidr_block
  az_count               = var.az_count
  newbits_private_subnet = var.newbits_private_subnet
  newbits_public_subnet  = var.newbits_public_subnet

  tags = {
    Project     = var.project_name
    environment = var.environment
    ManagedBy   = "Terraform"
  }

}
