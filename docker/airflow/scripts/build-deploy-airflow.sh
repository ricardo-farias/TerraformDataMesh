#!/bin/bash

# Config
REGION=us-east-2
ECR_REPO_URL="<base_ecr_image_url>"

if [ $? -eq 0 ]; then
  ECR_URL=`for i in $(echo $ECR_REPO_URL | tr "/" "\n")
  do
    echo $i
  done | sed -n 1p`
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL
fi

docker build --no-cache -t airflow docker/airflow/
docker tag airflow:latest $ECR_REPO_URL

if [ $? -eq 0 ]; then
  docker push $ECR_REPO_URL
fi
