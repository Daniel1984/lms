package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"time"

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
	tableName, ok := os.LookupEnv("TABLE_NAME")
	if !ok {
		log.Printf("could not allocate %s env var", "TABLE_NAME")
		os.Exit(1)
	}

	body, err := ioutil.ReadAll(strings.NewReader(req.Body))
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	book := types.Book{}
	if err := json.Unmarshal(body, &book); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	svc := dynamodb.New(sess)

	newChangelogtem, err := dynamodbattribute.Marshal(book.Changelog())
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	ncl := []*dynamodb.AttributeValue{newChangelogtem}

	input := &dynamodb.UpdateItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(book.ID),
			},
			"author": {
				S: aws.String(book.Author),
			},
		},
		ExpressionAttributeValues: map[string]*dynamodb.AttributeValue{
			":t": {
				S: aws.String(book.Title),
			},
			":d": {
				S: aws.String(book.Description),
			},
			":i": {
				S: aws.String(book.ISBN),
			},
			":u": {
				S: aws.String(time.Now().UTC().Format(time.RFC3339)),
			},
			":ncl": {
				L: ncl,
			},
		},
		TableName:        aws.String(tableName),
		ReturnValues:     aws.String("UPDATED_NEW"),
		UpdateExpression: aws.String("set title = :t, description = :d, isbn = :i, updated_at = :u, changelog = list_append(changelog, :ncl)"),
	}

	if _, err := svc.UpdateItem(input); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	return rw.RespondWithOK([]byte("OK")), nil
}
