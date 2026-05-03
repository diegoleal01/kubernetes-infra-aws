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
