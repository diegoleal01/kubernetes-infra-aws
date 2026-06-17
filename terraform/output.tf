output "control_plane_ids" {
  description = "List of instance IDs for control plane nodes."
  value       = module.ec2.control_plane_ids
}

output "worker_ids" {
  description = "List of instance IDs for worker nodes."
  value       = module.ec2.worker_ids
}