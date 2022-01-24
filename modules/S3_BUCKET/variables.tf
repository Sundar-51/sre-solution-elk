variable "aws_s3_bucket_name" {
  type = string
  default = "elk-key-bucket"
}
variable "aws_s3_shell_bucket_name" {
  type = string
  #default = "aws-s3-shell-bucket"
}
variable "acl" {
  type = list (string)
  default = ["private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "log-delivery-write"]
}
variable "key_name" {
  
}