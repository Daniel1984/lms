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
	tableName, ok := os.LookupEnv("TABLE_NAME")
	if !ok {
		log.Printf("could not allocate %s env var", "TABLE_NAME")
		os.Exit(1)
	}

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	svc := dynamodb.New(sess)

	params := &dynamodb.ScanInput{
		TableName: aws.String(tableName),
	}

	result, err := svc.Scan(params)
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	items := []types.Book{}
	if err = dynamodbattribute.UnmarshalListOfMaps(result.Items, &items); err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	resBytes, err := json.Marshal(items)
	if err != nil {
		return rw.RespondWithError(400, []byte(err.Error())), nil
	}

	return rw.RespondWithOK([]byte(resBytes)), nil
}
