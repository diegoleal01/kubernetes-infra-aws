#VPC
variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deploy environment (e.g: dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones to deploy resources across"
  type        = number
}

variable "newbits_private_subnet" {
  description = "Number of additional bits to extend the VPC CIDR for private subnets. E.g., 8 bits on a /16 VPC yields /24 subnets"
  type        = number
}

variable "newbits_public_subnet" {
  description = "Number of additional bits to extend the VPC CIDR for public subnets. E.g., 8 bits on a /16 VPC yields /24 subnets"
  type        = number
}

#EC2
variable "name_prefix" {
  description = "Prefix used to name EC2 instances (e.g., 'k8s-infra-dev')."
  type        = string
}

variable "control_plane_count" {
  description = "Number of control plane nodes. Must be odd to maintain etcd quorum."
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of worker nodes."
  type        = number
  default     = 2
}

variable "control_plane_instance_type" {
  description = "EC2 instance type for control plane nodes."
  type        = string
}

variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes."
  type        = string
}

variable "nlb_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the API server via the NLB (port 6443)."
  type        = list(string)
}