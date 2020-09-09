# Project Configuration
project_name = "mj-data-mesh-poc"
environment = "lex"
aws_region = "us-east-2"


subnet_id = "<subet_id>"
vpc_id = "<vpc_id>"

key_name = "EMR-key-pair"
ingress_cidr_blocks = "0.0.0.0/0"
release_label = "emr-5.30.0"
applications = ["Spark", "Zeppelin", "JupyterHub"]

# Master node configurations
master_instance_type = "m5.xlarge"

# Slave nodes configurations
core_instance_type = "m5.xlarge"
core_instance_count = 1

database_name = "DataMeshCatalogue"

# S3 Buckets
cluster_name = "Airflow"