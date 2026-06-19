output "control_plane_sg_id" {
  description = "ID of the security group for control plane nodes."
  value       = aws_security_group.control_plane.id
}

output "worker_sg_id" {
  description = "ID of the security group for worker nodes."
  value       = aws_security_group.worker.id
}

output "nlb_sg_id" {
  description = "Security group ID of the NLB."
  value       = aws_security_group.nlb.id
}
