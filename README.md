# kubernetes-infra-aws

> **Status: work in progress**

End-to-end automation for provisioning a high-availability Kubernetes cluster on AWS. Terraform provisions the infrastructure (VPC, EC2, NLB, security groups); Ansible bootstraps the cluster via kubeadm. All nodes run in private subnets with access exclusively through AWS SSM — no port 22 exposed.

## Stack

- **Terraform** — VPC, EC2, NLB, security groups
- **Ansible** — containerd, kubeadm, cluster bootstrap (in progress)
- **Kubernetes** — kubeadm, 3 control planes (HA), Flannel CNI
- **CI/CD** — GitHub Actions with OIDC (planned)

## Roadmap

- [x] VPC (external module, versioned)
- [x] EC2 instances with SSM access
- [x] Security groups with least-privilege SG-to-SG rules
- [x] NLB fronting the API server on port 6443
- [ ] Ansible roles and playbook
- [ ] End-to-end cluster bootstrap validation
- [ ] GitHub Actions pipeline with OIDC
