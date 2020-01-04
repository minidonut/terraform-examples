/**
 * Lambda
 */

resource "aws_iam_role" "template-api" {
  name = "LambdaRole_TemplateAPI"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "template-api" {
  role       = aws_iam_role.template-api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// If there are needs for custom policy
/*
resource "aws_iam_policy" "template-api" {
  name = "LambdaPolicy_TemplateAPI"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": []
}
EOF
}

resource "aws_iam_role_policy_attachment" "template-api-custom" {
  role       = aws_iam_role.template-api.name
  policy_arn = aws_iam_policy.template-api.arn
}
*/

resource "aws_lambda_function" "template-api" {
  function_name = "template-api"
  filename      = "files/lambda-go.zip"
  role          = aws_iam_role.template-api.arn
  handler       = "main"
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 300

  environment {
    variables = {
      APP_ENV = "production"
    }
  }
}

resource "aws_lambda_permission" "template-api" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.template-api.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-northeast-2:${var.account_id}:${var.api_id}/*/*"
}

resource "aws_cloudwatch_log_group" "template-api" {
  name = "/aws/lambda/template-api"
}
