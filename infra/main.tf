provider "aws" {
  region = var.aws_region
}

resource "aws_dynamodb_table" "jokes" {
  name         = var.jokes_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "joke_lambda_exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "dynamodb:Scan"
    ]
    resources = [aws_dynamodb_table.jokes.arn]
  }

  statement {
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "joke_lambda_policy"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "joke_emailer" {
  filename         = var.lambda_zip_path
  function_name    = "joke_emailer_lambda"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "main"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      JOKES_TABLE = aws_dynamodb_table.jokes.name
      EMAIL_TO    = var.email_to
      EMAIL_FROM  = var.email_from
      AWS_REGION  = var.aws_region
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_day" {
  name                = "every_day_joke"
  schedule_expression = "cron(0 12 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.every_day.name
  target_id = "joke_lambda"
  arn       = aws_lambda_function.joke_emailer.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.joke_emailer.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_day.arn
}