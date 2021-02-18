package main

import (
	"encoding/json"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	rw "github.com/lms/pkg/responsewriter"
	"github.com/lms/pkg/types"
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
	result, err := svc.GetItem(&dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(bookID),
			},
			"author": {
				S: aws.String(author),
			},
		},
	})
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	if result.Item == nil {
		return rw.RespondWithError(400, []byte("book not found")), nil
	}

	book := types.Book{}
	if err = dynamodbattribute.UnmarshalMap(result.Item, &book); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	resBytes, err := json.Marshal(book)
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	return rw.RespondWithOK([]byte(resBytes)), nil
}
