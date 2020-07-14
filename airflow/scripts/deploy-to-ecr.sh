aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 150222441608.dkr.ecr.us-east-2.amazonaws.com
docker build -t airflow .
docker tag airflow:latest 150222441608.dkr.ecr.us-east-2.amazonaws.com/airflow:latest
docker push 150222441608.dkr.ecr.us-east-2.amazonaws.com/airflow:latest