#!/usr/bin/env bash
set -e

rootDir=$PWD

export TF_VAR_api_deployed_at=$(date +%s)

for d in ../cmd/*; do
  echo "Building $d"
  cd $d && GOOS=linux GOARCH=amd64 go build main.go
  cd $rootDir
done

cd $rootDir
terraform plan && terraform apply -auto-approve
