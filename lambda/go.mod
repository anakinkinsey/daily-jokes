module github.com/anakinkinsey/daily-jokes-lambda

go 1.22

toolchain go1.24.4

require (
	github.com/aws/aws-lambda-go v1.38.0
	github.com/aws/aws-sdk-go-v2 v1.36.3
	github.com/aws/aws-sdk-go-v2/config v1.26.0
	github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue v1.19.0
	github.com/aws/aws-sdk-go-v2/service/dynamodb v1.43.1
	github.com/aws/aws-sdk-go-v2/service/ses v1.23.0
)

require (
	github.com/aws/aws-sdk-go-v2/credentials v1.16.11 // indirect
	github.com/aws/aws-sdk-go-v2/feature/ec2/imds v1.14.10 // indirect
	github.com/aws/aws-sdk-go-v2/internal/configsources v1.3.34 // indirect
	github.com/aws/aws-sdk-go-v2/internal/endpoints/v2 v2.6.34 // indirect
	github.com/aws/aws-sdk-go-v2/internal/ini v1.7.1 // indirect
	github.com/aws/aws-sdk-go-v2/service/dynamodbstreams v1.25.3 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/accept-encoding v1.12.3 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/endpoint-discovery v1.10.15 // indirect
	github.com/aws/aws-sdk-go-v2/service/internal/presigned-url v1.10.9 // indirect
	github.com/aws/aws-sdk-go-v2/service/sso v1.18.4 // indirect
	github.com/aws/aws-sdk-go-v2/service/ssooidc v1.21.4 // indirect
	github.com/aws/aws-sdk-go-v2/service/sts v1.26.4 // indirect
	github.com/aws/smithy-go v1.22.2 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
)
