variable "aws_region" {
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "jokes_table_name" {
  description = "Name of the DynamoDB table for jokes"
  default     = "Jokes"
}

variable "lambda_zip_path" {
  description = "Path to the Lambda deployment package zip"
  default     = "../infra/function.zip"
  type        = string
}

variable "email_to" {
  description = "Recipient email for the joke"
  type        = string
}

variable "email_from" {
  description = "SES verified sender email address"
  type        = string
}