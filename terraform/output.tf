output "control_plane_ids" {
  description = "List of instance IDs for control plane nodes."
  value       = module.ec2.control_plane_ids
}

output "worker_ids" {
  description = "List of instance IDs for worker nodes."
  value       = module.ec2.worker_ids
}

output "control_plane_endpoint" {
  description = "DNS name of the NLB fronting the Kubernetes API server."
  value       = module.balancer.nlb_dns_name
}
