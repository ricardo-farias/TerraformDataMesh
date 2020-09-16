docker build -t airflow . --no-cache
docker tag airflow:latest 150222441608.dkr.ecr.us-east-2.amazonaws.com/airflow:latest