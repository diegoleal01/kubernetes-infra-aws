module "vpc" {
  source = "github.com/diegoleal01/terraform-aws-vpc?ref=v1.0.1"

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

module "security" {
  source = "./modules/security"

  name_prefix             = var.name_prefix
  vpc_id                  = module.vpc.vpc_id
  nlb_allowed_cidr_blocks = var.nlb_allowed_cidr_blocks
  tags                    = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  name_prefix                 = var.name_prefix
  control_plane_count         = var.control_plane_count
  worker_count                = var.worker_count
  control_plane_instance_type = var.control_plane_instance_type
  worker_instance_type        = var.worker_instance_type
  subnet_ids                  = values(module.vpc.private_subnet_ids)
  security_group_ids_cp       = [module.security.control_plane_sg_id]
  security_group_ids_worker   = [module.security.worker_sg_id]
  public_key_path             = var.public_key_path
  tags                        = local.common_tags
}

module "balancer" {
  source = "./modules/balancer"

  name_prefix       = var.name_prefix
  public_subnet_ids = values(module.vpc.public_subnet_ids)
  vpc_id            = module.vpc.vpc_id
  control_plane_ids = module.ec2.control_plane_ids
  nlb_sg_id         = module.security.nlb_sg_id
  tags              = local.common_tags
}
