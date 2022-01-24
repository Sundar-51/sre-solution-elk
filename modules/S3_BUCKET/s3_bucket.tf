#s3 bucket
resource "aws_s3_bucket" "elk_key_bucket" {
  bucket = var.aws_s3_bucket_name
  acl    = var.acl[0]
  versioning {
    enabled = true
  }
}
#s3 upload
resource "aws_s3_bucket_object" "tls_key" {
  bucket = var.aws_s3_bucket_name
  key    = var.key_name
  source = "./${var.key_name}"
  depends_on = [aws_s3_bucket.elk_key_bucket] 
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = filemd5("path/to/file")
}