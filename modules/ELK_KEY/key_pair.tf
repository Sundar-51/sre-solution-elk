#KEY PAIR 
resource "tls_private_key" "elk_key" {
  algorithm = var.algorithm
}
resource "aws_key_pair" "elk_key"{

  key_name   = var.key_name
  public_key = tls_private_key.elk_key.public_key_openssh
}
resource "local_file" "els_pem_key" {
  filename= "./${var.key_name}"
  content = tls_private_key.elk_key.private_key_pem
}
