package main

import (
	"context"
	"fmt"
	"math/rand"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	ddbTypes "github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/aws/aws-sdk-go-v2/service/ses"
	sesTypes "github.com/aws/aws-sdk-go-v2/service/ses/types"
)

var (
	jokesTable = os.Getenv("JOKES_TABLE")
	emailTo    = os.Getenv("EMAIL_TO")
	emailFrom  = os.Getenv("EMAIL_FROM")
	awsRegion  = os.Getenv("AWS_REGION")
)

type Joke struct {
	ID   string `dynamodbav:"id"`
	Text string `dynamodbav:"text"`
}

func fetchAllJokes(ctx context.Context, client *dynamodb.Client) ([]Joke, error) {
	input := &dynamodb.ScanInput{
		TableName: aws.String(jokesTable),
	}
	result, err := client.Scan(ctx, input)
	if err != nil {
		return nil, err
	}
	var jokes []Joke
	err = attributevalue.UnmarshalListOfMaps(result.Items, &jokes)
	return jokes, err
}

func sendEmail(ctx context.Context, client *ses.Client, subject, body string) error {
	input := &ses.SendEmailInput{
		Destination: &sesTypes.Destination{
			ToAddresses: []string{emailTo},
		},
		Message: &sesTypes.Message{
			Body: &sesTypes.Body{
				Text: &sesTypes.Content{
					Charset: aws.String("UTF-8"),
					Data:    aws.String(body),
				},
			},
			Subject: &sesTypes.Content{
				Charset: aws.String("UTF-8"),
				Data:    aws.String(subject),
			},
		},
		Source: aws.String(emailFrom),
	}
	_, err := client.SendEmail(ctx, input)
	return err
}

func handler(ctx context.Context) error {
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(awsRegion))
	if err != nil {
		return fmt.Errorf("failed to load AWS config: %v", err)
	}

	ddb := dynamodb.NewFromConfig(cfg)
	sesClient := ses.NewFromConfig(cfg)

	jokes, err := fetchAllJokes(ctx, ddb)
	if err != nil {
		return fmt.Errorf("error fetching jokes: %v", err)
	}
	if len(jokes) == 0 {
		return fmt.Errorf("no jokes found in table")
	}

	rand.Seed(time.Now().UnixNano())
	joke := jokes[rand.Intn(len(jokes))]

	subject := "Your Daily Joke!"
	body := joke.Text
	if err := sendEmail(ctx, sesClient, subject, body); err != nil {
		return fmt.Errorf("error sending email: %v", err)
	}
	return nil
}

func main() {
	lambda.Start(handler)
}