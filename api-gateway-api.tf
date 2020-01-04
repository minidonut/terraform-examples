/**
 * REST API
 */

resource "aws_api_gateway_rest_api" "api" {
  name        = "My Lambda API"
  description = "This is a sample Lambda API"
  binary_media_types = [
    "image/*",
    "multipart/form-data"
  ]
}

/**
 * Deployment
 */

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}

resource "aws_cloudwatch_log_group" "api" {
  name = "/aws/apigateway/my-lambda-api/execution-logs"
}

resource "aws_api_gateway_stage" "v1" {
  depends_on = [aws_api_gateway_deployment.api]

  stage_name           = "v1"
  rest_api_id          = aws_api_gateway_rest_api.api.id
  deployment_id        = aws_api_gateway_deployment.api.id
  cache_cluster_enabled = true
  cache_cluster_size = 0.5

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api.arn
    format = "{ 'requestId': '$context.requestId', 'ip': '$context.identity.sourceIp', 'caller': '$context.identity.caller', 'user': '$context.identity.user', 'requestTime': '$context.requestTime', 'httpMethod': '$context.httpMethod', 'resourcePath': '$context.resourcePath', 'status': '$context.status', 'protocol': '$context.protocol', 'responseLength': '$context.responseLength' }"
  }
}

resource "aws_api_gateway_domain_name" "api" {
  domain_name     = var.api_domain
  certificate_arn = module.us-east-1.acm_certificate_arn
}

resource "aws_api_gateway_base_path_mapping" "api" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_deployment.api.stage_name
  domain_name = aws_api_gateway_domain_name.api.domain_name
}

resource "aws_api_gateway_usage_plan" "basic" {
  name         = "basic-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_deployment.api.stage_name
  }

  quota_settings {
    limit  = 5000
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 100
    rate_limit  = 500
  }
}
