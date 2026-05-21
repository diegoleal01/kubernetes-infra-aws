variable "name_prefix" {
  description = "Prefix used to name EC2 instances (e.g., 'k8s-infra-dev')."
  type        = string
}

variable "control_plane_count" {
  description = "Number of control plane nodes. Must be odd to maintain etcd quorum."
  type        = number
  default     = 3

  validation {
    condition     = var.control_plane_count % 2 != 0
    error_message = "control_plane_count must be an odd number (1, 3, 5...) to maintain etcd quorum."
  }
}

variable "worker_count" {
  description = "Number of worker nodes."
  type        = number
  default     = 2

  validation {
    condition     = var.worker_count >= 1
    error_message = "worker_count must be at least 1."
  }
}

variable "control_plane_instance_type" {
  description = "EC2 instance type for control plane nodes."
  type        = string
}

variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes."
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs to distribute instances across."
  type        = list(string)
  default     = [""]

  validation {
    condition     = length(var.subnet_ids) >= 1
    error_message = "At least one subnet ID must be provided."
  }
}

variable "security_group_ids_cp" {
  description = "List of security group IDs to attach to control plane instances."
  type        = list(string)
}

variable "security_group_ids_worker" {
  description = "List of security group IDs to attach to worker instances."
  type        = list(string)
}

variable "root_volume_size" {
  description = "Size in GiB for the root EBS volume on all instances."
  type        = number
  default     = 30

  validation {
    condition     = var.root_volume_size >= 20
    error_message = "root_volume_size must be at least 20 GiB for Kubernetes workloads."
  }
}

variable "tags" {
  description = "Additional tags to apply to all instances."
  type        = map(string)
  default     = {}
}
