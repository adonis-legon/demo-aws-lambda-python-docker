resource "aws_iam_role" "demo_aws_lambda_python_docker_role" {
  name = "${terraform.workspace}-${var.lambda_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
      }
    ]
  })

  inline_policy {
    name = "${terraform.workspace}-${var.lambda_name}-permission"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:aws:logs:*:*:*"
          Effect = "Allow"
        }
      ]
    })
  }

  tags = {
    app = var.lambda_name
  }
}

resource "aws_cloudwatch_log_group" "demo_aws_lambda_python_docker_logs" {
  name              = "/aws/lambda/${terraform.workspace}-${var.lambda_name}"
  retention_in_days = 5

  tags = {
    app = var.lambda_name
  }
}

resource "aws_lambda_function" "demo_aws_lambda_python_docker" {
  function_name  = "${terraform.workspace}-${var.lambda_name}"
  description    = "Demo AWS Lambda function in Python"

  role           = aws_iam_role.demo_aws_lambda_python_docker_role.arn

  image_uri      = "${var.aws_account}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.lambda_name}:${var.lambda_version}"
  package_type   = "Image"
  publish        = true

  architectures = [ "x86_64" ]
  memory_size    = 128

  tags = {
    app = var.lambda_name
  }
}

resource "aws_lambda_alias" "demo_aws_lambda_python_docker_alias" {
  name             = "${terraform.workspace}-${var.lambda_name}-life"
  function_name    = aws_lambda_function.demo_aws_lambda_python_docker.arn
  function_version = "$LATEST"
}