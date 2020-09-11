#!/bin/bash

echo "This script assumes that it is ran from the root project directory. Make sure that it is ran from the correct directory."

# Region
REGION=us-east-2

# Address of the ECR repository
ECR_BASE_URL=<ECR-Repo-URL>

if [ $? -eq 0 ]; then
  ECR_URL=`for i in $(echo $ECR_BASE_URL | tr "/" "\n")
  do
    echo $i
  done | sed -n 1p`
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL
fi

docker build --no-cache -t airflow docker/airflow/
docker tag airflow:latest $ECR_BASE_URL

if [ $? -eq 0 ]; then
  docker push $ECR_BASE_URL
fi
