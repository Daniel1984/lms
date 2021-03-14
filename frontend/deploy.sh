#!/usr/bin/env bash
set -e

echo "Building assets"
NODE_ENV=production yarn build

echo "Updating assets"
terraform plan -out terraform.tfplan && terraform apply -auto-approve "terraform.tfplan"

echo "cleanup!"
rm -rf build
