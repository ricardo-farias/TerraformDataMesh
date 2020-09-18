docker build -t python-aws .
docker tag python-aws localhost:5000/python-aws:latest
docker push localhost:5000/python-aws:latest