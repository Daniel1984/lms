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
	"github.com/gofrs/uuid"
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

	uid, err := uuid.NewV4()
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	now := time.Now().UTC()
	book.ID = uid.String()
	book.CreatedAt = now
	book.UpdatedAt = now
	book.ChangeLog = append(book.ChangeLog, book.Changelog())

	item, err := dynamodbattribute.MarshalMap(book)
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	input := &dynamodb.PutItemInput{
		Item:                   item,
		ReturnConsumedCapacity: aws.String("TOTAL"),
		TableName:              aws.String(tableName),
	}

	if _, err := svc.PutItem(input); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	return rw.RespondWithOK([]byte("OK")), nil
}
