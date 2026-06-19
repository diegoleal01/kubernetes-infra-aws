resource "aws_security_group" "control_plane" {
  name        = "${var.name_prefix}-control-plane-sg"
  description = "Security group for Kubernetes control plane nodes"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-control-plane-sg" })
}

resource "aws_security_group" "worker" {
  name        = "${var.name_prefix}-worker-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-worker-sg" })
}

resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-nlb-sg"
  description = "Security group for NLB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name_prefix}-nlb-sg" })
}

# --- Control plane inbound rules ---

resource "aws_security_group_rule" "cp_ingress_api_from_workers" {
  description              = "Kubernetes API from worker nodes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.worker.id
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
}

resource "aws_security_group_rule" "cp_ingress_api_from_cp" {
  description              = "Kubernetes API between control planes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
}

resource "aws_security_group_rule" "cp_ingress_etcd" {
  description              = "etcd between control planes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "tcp"
  from_port                = 2379
  to_port                  = 2380
}

resource "aws_security_group_rule" "cp_ingress_kubelet" {
  description              = "kubelet on control plane nodes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
}

resource "aws_security_group_rule" "cp_ingress_flannel_from_cp" {
  description              = "Flannel VXLAN between control planes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "udp"
  from_port                = 8472
  to_port                  = 8472
}

resource "aws_security_group_rule" "cp_ingress_flannel_from_workers" {
  description              = "Flannel VXLAN from worker nodes"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.worker.id
  protocol                 = "udp"
  from_port                = 8472
  to_port                  = 8472
}

resource "aws_security_group_rule" "cp_ingress_apiserver_from_nlb" {
  description              = "Kubernetes API from NLB"
  type                     = "ingress"
  security_group_id        = aws_security_group.control_plane.id
  source_security_group_id = aws_security_group.nlb.id
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
}

# --- Worker inbound rules ---

resource "aws_security_group_rule" "worker_ingress_kubelet_from_cp" {
  description              = "kubelet on worker nodes, called by control plane"
  type                     = "ingress"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "tcp"
  from_port                = 10250
  to_port                  = 10250
}

resource "aws_security_group_rule" "worker_ingress_flannel_from_cp" {
  description              = "Flannel VXLAN from control planes"
  type                     = "ingress"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "udp"
  from_port                = 8472
  to_port                  = 8472
}

resource "aws_security_group_rule" "worker_ingress_flannel_from_workers" {
  description              = "Flannel VXLAN between worker nodes"
  type                     = "ingress"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  protocol                 = "udp"
  from_port                = 8472
  to_port                  = 8472
}

# --- NLB inbound rules ---

resource "aws_security_group_rule" "nlb_ingress_apiserver_from_user" {
  description       = "Kubernetes API from user IP"
  type              = "ingress"
  cidr_blocks       = var.nlb_allowed_cidr_blocks
  security_group_id = aws_security_group.nlb.id
  protocol          = "tcp"
  from_port         = 6443
  to_port           = 6443
}

# --- Egress rules (both SGs) ---

resource "aws_security_group_rule" "cp_egress_all" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  security_group_id = aws_security_group.control_plane.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
}

resource "aws_security_group_rule" "worker_egress_all" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  security_group_id = aws_security_group.worker.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
}

resource "aws_security_group_rule" "nlb_egress_to_cp" {
  description              = "Allow outbound traffic to Control Planes"
  type                     = "egress"
  security_group_id        = aws_security_group.nlb.id
  source_security_group_id = aws_security_group.control_plane.id
  protocol                 = "tcp"
  from_port                = 6443
  to_port                  = 6443
}