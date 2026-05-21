output "control_plane_ids" {
  description = "List of instance IDs for control plane nodes."
  value       = aws_instance.control_plane[*].id
}

output "control_plane_private_ips" {
  description = "List of private IP addresses for control plane nodes."
  value       = aws_instance.control_plane[*].private_ip
}

output "worker_ids" {
  description = "List of instance IDs for worker nodes."
  value       = aws_instance.worker[*].id
}

output "worker_private_ips" {
  description = "List of private IP addresses for worker nodes."
  value       = aws_instance.worker[*].private_ip
}
