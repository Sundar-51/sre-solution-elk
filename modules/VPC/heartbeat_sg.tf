#SECURITY GROUP - 1 FOR INSTANCES
resource "aws_security_group" "heartbeat-sg" {
  name   = var.heartbeat_security_group
  vpc_id = aws_vpc.vpc[0].id
  description = "heartbeat instances security group"
  dynamic "ingress" {
    for_each = var.heartbeat_instances_ingress_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = var.protocol[0]
      cidr_blocks = var.all_cidr
    }
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "egress" {
    for_each = var.heartbeat_instances_egress_ports
    content {
      from_port = egress.value
      to_port = egress.value
      protocol = var.protocol[2]
      cidr_blocks = var.all_cidr
    }
  }
}