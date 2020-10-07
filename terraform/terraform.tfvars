# Project Configuration
project_name = "aaa-project"
environment = "aaa-environment"
aws_region = "us-east-2"

# EMR Configuration
subnet_id = "<subet_id>"
vpc_id = "<vpc_id>"
key_name = "EMR-key-pair"
ingress_cidr_blocks = "0.0.0.0/0"
release_label = "emr-5.30.0"
applications = ["Spark", "Zeppelin", "JupyterHub"]
master_instance_type = "m5.xlarge"
core_instance_type = "m5.xlarge"
core_instance_count = 1

glue_db_name = "DataMeshCatalogue"

# EKS
cluster_name = "Airflow"
