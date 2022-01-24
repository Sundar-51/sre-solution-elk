resource "aws_s3_bucket" "elk_shell_bucket" {
  bucket = var.aws_s3_shell_bucket_name
  acl    = var.acl[2]
  versioning {
    enabled = true
  }
}
resource "aws_s3_bucket_object" "elk_shell_bucket_objects" {
  for_each = fileset("./modules/S3_BUCKET/shell_scripts/", "*")
  bucket = aws_s3_bucket.elk_shell_bucket.id
  key = each.value
  acl = var.acl[2]
  source = "./modules/S3_BUCKET/shell_scripts/${each.value}"
  etag = filemd5("./modules/S3_BUCKET/shell_scripts/${each.value}")
}