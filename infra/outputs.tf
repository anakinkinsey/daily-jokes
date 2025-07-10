output "dynamodb_table" {
  value = aws_dynamodb_table.jokes.name
}

output "lambda_function_name" {
  value = aws_lambda_function.joke_emailer.function_name
}