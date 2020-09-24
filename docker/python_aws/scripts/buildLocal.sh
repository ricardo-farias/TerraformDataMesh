docker build --no-cache -t python-aws docker/python_aws/
docker tag python-aws localhost:5000/python-aws:latest
docker push localhost:5000/python-aws:latest