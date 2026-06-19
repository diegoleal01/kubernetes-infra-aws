variable "name_prefix" {
  description = "Prefix used to name NLB resources (e.g., 'k8s-infra-dev')."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all NLB resources."
  type        = map(string)
  default     = {}
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to attach to the Network Load Balancer."
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the NLB target group will be created."
  type        = string
}

variable "control_plane_ids" {
  description = "List of Control Plane instance IDs to register in the NLB target group."
  type        = list(string)
}

variable "nlb_sg_id" {
  description = "List of Control Plane instance IDs to register in the NLB target group."
  type        = string
}