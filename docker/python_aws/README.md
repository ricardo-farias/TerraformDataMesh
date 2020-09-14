## Local Setup

```
# Setup virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Installing Requirements
pip install -r requirements.txt
```

## Build Docker Image

```
docker build -t python-aws .
docker tag python-aws localhost:5000/python-aws:latest

# Pushing to Local Docker Repo
docker push localhost:5000/python-aws:latest
```

## Running Docker Build
```
docker run python-aws:latest
```

