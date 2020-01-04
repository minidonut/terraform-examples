module "my-lambda" {
  source = "./my-lambda"
  account_id = var.account_id
  api_id = aws_api_gateway_rest_api.api.id
  api_root_resource_id = aws_api_gateway_rest_api.api.root_resource_id
}

module "us-east-1" {
  source = "./us-east-1"
  domain = var.domain
}
