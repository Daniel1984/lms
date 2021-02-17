package main

import (
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	rw "github.com/lms/pkg/responsewriter"
)

func main() {
	lambda.Start(Run)
}

func Run(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	bookID := req.QueryStringParameters["bookID"]
	if len(bookID) == 0 {
		return rw.RespondWithError(400, []byte("missing 'bookID' in query params")), nil
	}

	author := req.QueryStringParameters["author"]
	if len(author) == 0 {
		return rw.RespondWithError(400, []byte("missing 'author' in query params")), nil
	}

	tableName, ok := os.LookupEnv("TABLE_NAME")
	if !ok {
		log.Printf("could not allocate %s env var", "TABLE_NAME")
		os.Exit(1)
	}

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	svc := dynamodb.New(sess)
	input := &dynamodb.DeleteItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(bookID),
			},
			"author": {
				S: aws.String(author),
			},
		},
		TableName: aws.String(tableName),
	}

	if _, err := svc.DeleteItem(input); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	return rw.RespondWithOK([]byte(fmt.Sprintf("DELETED %s", bookID))), nil
}
