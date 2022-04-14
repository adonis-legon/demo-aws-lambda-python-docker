output "lambda_function_api_url" {
  value = aws_api_gateway_stage.demo_aws_lambda_python_docker_api_stage.invoke_url
}