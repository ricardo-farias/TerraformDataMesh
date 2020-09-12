FROM python:3.8-slim

COPY . /python-aws

WORKDIR python-aws

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "main.py"]