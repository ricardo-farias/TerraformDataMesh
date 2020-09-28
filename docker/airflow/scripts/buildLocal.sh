docker build --no-cache -t airflow-local docker/airflow/
docker tag airflow-local localhost:5000/airflow-local
docker push localhost:5000/airflow-local:latest