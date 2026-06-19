variable "name_prefix" {
  description = "Prefix used to name security groups."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all security groups."
  type        = map(string)
  default     = {}
}

variable "nlb_allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the API server via the NLB (port 6443)."
  type        = list(string)
}
