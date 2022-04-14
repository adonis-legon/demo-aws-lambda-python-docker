resource "aws_iam_role" "api_gateway_account_logs_role" {
  name = "api-gateway-account-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
      name = "api-gateway-account-logs-permission"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action: [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:DescribeLogGroups",
                    "logs:DescribeLogStreams",
                    "logs:PutLogEvents",
                    "logs:GetLogEvents",
                    "logs:FilterLogEvents"
                ],
            Effect   = "Allow"
            Resource = "*"
            }
        ]
    })
  }

  tags = {
    app = var.lambda_name
  }
}

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_account_logs_role.arn
}

resource "aws_api_gateway_rest_api" "demo_aws_lambda_python_docker_api" {
  name = "${terraform.workspace}-${var.lambda_name}-api"

  depends_on = [
    aws_api_gateway_account.api_gateway_account
  ]
  
  tags = {
    app = var.lambda_name
  }
}

resource "aws_api_gateway_resource" "demo_aws_lambda_python_docker_api_resource" {
  path_part   = "sum"
  parent_id   = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id
}

resource "aws_api_gateway_method" "demo_aws_lambda_python_docker_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id
  resource_id   = aws_api_gateway_resource.demo_aws_lambda_python_docker_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_iam_role" "demo_aws_lambda_python_docker_api_role" {
  name = "${terraform.workspace}-${var.lambda_name}-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
  path = "/"
  inline_policy {
    name = "${terraform.workspace}-${var.lambda_name}-api-permission"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = "lambda:InvokeFunction"
          Effect   = "Allow"
          Resource = aws_lambda_function.demo_aws_lambda_python_docker.arn
        },
      ]
    })
  }

  tags = {
    app = var.lambda_name
  }
}

resource "aws_api_gateway_integration" "demo_aws_lambda_python_docker_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id
  resource_id             = aws_api_gateway_resource.demo_aws_lambda_python_docker_api_resource.id
  http_method             = aws_api_gateway_method.demo_aws_lambda_python_docker_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.demo_aws_lambda_python_docker.invoke_arn
  credentials             = aws_iam_role.demo_aws_lambda_python_docker_api_role.arn
}

resource "aws_api_gateway_deployment" "demo_aws_lambda_python_docker_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id

  depends_on = [
    aws_api_gateway_integration.demo_aws_lambda_python_docker_api_integration
  ]
}

resource "aws_api_gateway_stage" "demo_aws_lambda_python_docker_api_stage" {
  deployment_id = aws_api_gateway_deployment.demo_aws_lambda_python_docker_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id
  stage_name    = var.environment_tag

  tags = {
    app = var.lambda_name
  }
}

resource "aws_api_gateway_method_settings" "demo_aws_lambda_python_docker_api_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.demo_aws_lambda_python_docker_api.id
  stage_name  = aws_api_gateway_stage.demo_aws_lambda_python_docker_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}