resource "aws_lb" "nlb" {
  name               = "${var.name_prefix}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = [var.nlb_sg_id]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nlb"
    }
  )
}

resource "aws_lb_target_group" "instance_target_group" {
  name        = "${var.name_prefix}-target-group"
  port        = 6443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener_target_group" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "nlb_target_group_attachment" {
  count = length(var.control_plane_ids)

  target_group_arn = aws_lb_target_group.instance_target_group.arn
  target_id        = var.control_plane_ids[count.index]
  port             = 6443
}