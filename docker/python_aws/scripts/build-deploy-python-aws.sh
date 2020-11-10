#!/bin/bash

# Config
REGION=us-east-2

# ECR_REPO_URI=<Platform-Shared-ECR-URI>
ECR_REPO_URI=161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-platform-shared-aperson

if [ $? -eq 0 ]; then
  ECR_URL=`for i in $(echo $ECR_REPO_URI | tr "/" "\n")
  do
    echo $i
  done | sed -n 1p`
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL
fi

docker build --no-cache -t python-aws docker/python_aws/
docker tag python-aws:latest $ECR_REPO_URI:python-aws-latest

if [ $? -eq 0 ]; then
  docker push $ECR_REPO_URI
fi
