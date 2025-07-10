# daily-jokes

A serverless app that emails you a random joke every day using AWS Lambda (Go), DynamoDB, SES, and Terraform.

## Features

- Go AWS Lambda reads a random joke from DynamoDB and emails it using SES.
- Scheduled daily via AWS EventBridge.
- Infrastructure managed with Terraform.

## Setup

### 1. Prerequisites

- AWS CLI, credentials, and SES sender email verified
- [Terraform](https://www.terraform.io/)
- Go (for Lambda build)

### 2. Build & Package Lambda

```bash
cd lambda
GOOS=linux GOARCH=amd64 go build -o main main.go
zip function.zip main
mv function.zip ../
```

### 3. Configure Terraform

Edit `infra/terraform.tfvars` or pass variables:

```
lambda_zip_path = "../function.zip"
email_to = "your@email.com"
email_from = "verified-ses-sender@email.com"
aws_region = "us-east-1"
```

### 4. Deploy Infrastructure

```bash
cd infra
terraform init
terraform apply
```

### 5. Add Jokes to DynamoDB

Use AWS Console or a script to add jokes (see `scripts/example-jokes.json`).

### 6. Done!

You’ll get a joke emailed to you every day 🎉

---

**Tips:**

- Make sure `email_from` is verified in SES for your region.
- To test locally, use AWS CLI to invoke Lambda or DynamoDB.
