# SECURITY GROUPS #
#SECURITY GROUP - 1 FOR INSTANCES
resource "aws_security_group" "kibana-sg" {
  name   = var.kibana_security_group
  vpc_id = aws_vpc.vpc[0].id
  description = "Kibana instances security group"
  dynamic "ingress" {
    for_each = var.kibana_instances_ingress_ports
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
    for_each = var.kibana_instances_egress_ports
    content {
      from_port = egress.value
      to_port = egress.value
      protocol = var.protocol[2]
      cidr_blocks = var.all_cidr
    }
  }
}
resource "aws_security_group" "kibana-lb-sg" {
  name   = var.kibana_lb_security_group
  vpc_id = aws_vpc.vpc[0].id
  description = "Kibana instances load balancer security group"
  dynamic "ingress" {
    for_each = var.kibana_instances_ingress_ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = var.protocol[0]
      cidr_blocks = var.all_cidr
    }
  }
  dynamic "egress" {
    for_each = var.kibana_instances_egress_ports
    content {
      from_port = egress.value
      to_port = egress.value
      protocol = var.protocol[2]
      cidr_blocks = var.all_cidr
    }
  }
}