#!/bin/bash

# Config
REGION=<aws-region>
ECR_URL=<ECR-Docker-URL>

if [ $? -eq 0 ]; then
  ECR_URL=`for i in $(echo $ECR_URL | tr "/" "\n")
  do
    echo $i
  done | sed -n 1p`
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL
fi

docker build --no-cache -t python_aws docker/python_aws/
docker tag python_aws:latest $ECR_URL

if [ $? -eq 0 ]; then
  docker push $ECR_URL
fi
