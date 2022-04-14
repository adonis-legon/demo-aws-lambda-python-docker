variable "environment_tag" {
  type = string
  nullable = false
}

variable "aws_access_key" {
  type = string
  nullable = false
}

variable "aws_secret_key" {
  type = string
  nullable = false
}

variable "aws_region" {
  type = string
  nullable = false
}

variable "aws_account" {
  type = string
  nullable = false
}

variable "lambda_name" {
  type = string
  nullable = false
}

variable "lambda_version" {
  type = string
  nullable = false
}

variable "lamdda_api_version" {
  type = string
  nullable = false
}