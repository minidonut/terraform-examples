resource "aws_s3_bucket" "lambda-packages" {
  bucket = var.s3_bucket_name_lambda_packages
}
