data "archive_file" "counter_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/counter"
  output_path = "${path.module}/counter-lambda.zip"
}

resource "aws_dynamodb_table" "visitor_counter" {
  name         = var.counter_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = local.common_tags
}

data "aws_iam_policy_document" "counter_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "counter_lambda" {
  name               = "${var.project_name}-counter-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.counter_lambda_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "counter_lambda_basic_execution" {
  role       = aws_iam_role.counter_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "counter_lambda_dynamodb" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
    ]
    resources = [aws_dynamodb_table.visitor_counter.arn]
  }
}

resource "aws_iam_role_policy" "counter_lambda_dynamodb" {
  name   = "${var.project_name}-counter-dynamodb"
  role   = aws_iam_role.counter_lambda.id
  policy = data.aws_iam_policy_document.counter_lambda_dynamodb.json
}

resource "aws_cloudwatch_log_group" "counter_lambda" {
  name              = "/aws/lambda/${var.counter_lambda_function_name}"
  retention_in_days = 30

  tags = local.common_tags
}

resource "aws_lambda_function" "counter" {
  function_name = var.counter_lambda_function_name
  role          = aws_iam_role.counter_lambda.arn
  runtime       = var.counter_lambda_runtime
  handler       = "app.handler"
  architectures = ["arm64"]

  filename         = data.archive_file.counter_lambda.output_path
  source_code_hash = data.archive_file.counter_lambda.output_base64sha256
  timeout          = var.counter_lambda_timeout_seconds

  environment {
    variables = {
      COUNTER_TABLE_NAME    = aws_dynamodb_table.visitor_counter.name
      COUNTER_PARTITION_KEY = var.counter_partition_key
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.counter_lambda,
  ]

  tags = local.common_tags
}

resource "aws_apigatewayv2_api" "counter" {
  name          = var.counter_api_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["content-type"]
    allow_methods = ["GET", "OPTIONS"]
    allow_origins = length(var.counter_allowed_origins) > 0 ? var.counter_allowed_origins : [
      "https://${var.domain_name}",
      "https://www.${var.domain_name}",
      "http://localhost:4321",
    ]
    max_age = 300
  }

  tags = local.common_tags
}

resource "aws_apigatewayv2_integration" "counter_lambda" {
  api_id                 = aws_apigatewayv2_api.counter.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.counter.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "counter_get" {
  api_id    = aws_apigatewayv2_api.counter.id
  route_key = "GET /counter"
  target    = "integrations/${aws_apigatewayv2_integration.counter_lambda.id}"
}

resource "aws_apigatewayv2_stage" "counter_default" {
  api_id      = aws_apigatewayv2_api.counter.id
  name        = "$default"
  auto_deploy = true

  tags = local.common_tags
}

resource "aws_lambda_permission" "counter_api_gateway" {
  statement_id  = "AllowInvokeFromApiGatewayCounter"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.counter.execution_arn}/*/*"
}
