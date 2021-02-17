#!/usr/bin/env bash
set -e

echo "Building assets"
NODE_ENV=production yarn build

echo "Updating assets"
aws s3 cp --recursive build/ s3://lsmfrontend --region eu-central-1 --profile lms

echo "cleanup!"
rm -rf build
