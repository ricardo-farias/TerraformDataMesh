#!/bin/bash

# Region
REGION=<aws-region>
ECR_URL=<ECR-Repo-URL>

if [ $? -eq 0 ]; then
  ECR_URL=`for i in $(echo $ECR_URL | tr "/" "\n")
  do
    echo $i
  done | sed -n 1p`
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL
fi

docker build --no-cache -t airflow docker/airflow/
docker tag airflow:latest $ECR_URL

if [ $? -eq 0 ]; then
  docker push $ECR_URL
fi
