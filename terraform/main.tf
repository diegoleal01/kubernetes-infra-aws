module "vpc" {
  source = "../terraform-aws-vpc-remote"

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

module "ec2" {
  source = "./modules/ec2"

  name_prefix                 = var.name_prefix
  control_plane_count         = var.control_plane_count
  worker_count                = var.worker_count
  control_plane_instance_type = var.control_plane_instance_type
  worker_instance_type        = var.worker_instance_type
  subnet_ids                  = values(module.vpc.private_subnet_ids)
  tags                        = local.common_tags
}
