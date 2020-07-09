from airflow.models import Variable


aws_access_key_id = Variable.get("aws_access_key_id"),
aws_secret_access_key = Variable.get("aws_secret_access_key")
