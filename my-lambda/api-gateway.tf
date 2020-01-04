/**
 * API Gateway
 */

resource "aws_api_gateway_resource" "template" {
  rest_api_id = var.api_id
  parent_id   = var.api_root_resource_id
  path_part   = "template"
}

resource "aws_api_gateway_method" "template" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.template.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "template" {
  rest_api_id             = var.api_id
  resource_id             = aws_api_gateway_resource.template.id
  http_method             = aws_api_gateway_method.template.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-2:lambda:path/2015-03-31/functions/${aws_lambda_function.template-api.arn}/invocations"
}

resource "aws_api_gateway_resource" "template-proxy" {
  rest_api_id = var.api_id
  parent_id   = aws_api_gateway_resource.template.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "template-proxy" {
  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.template-proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "template-proxy" {
  rest_api_id             = var.api_id
  resource_id             = aws_api_gateway_resource.template-proxy.id
  http_method             = aws_api_gateway_method.template-proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-northeast-2:lambda:path/2015-03-31/functions/${aws_lambda_function.template-api.arn}/invocations"
}
