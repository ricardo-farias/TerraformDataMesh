## Create Repo
aws ecr create-repository --repository-name python-aws

## Build Docker Image
```
docker build -t python-aws .
docker tag python-aws localhost:5000/python-aws:latest
docker push localhost:5000/python-aws:latest
```

## Running Docker Build
```
docker run python-aws:latest
```

## Docker-Compose
```
docker-compose up --force-recreate --no-deps --build
```
