# NETWORKING #
#VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr#[count.index]
  enable_dns_hostnames = var.enable_dns_hostnames
  count = var.vpc_count
}

