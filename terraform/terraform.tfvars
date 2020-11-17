# Project Configuration
project_name = "data-mesh-poc"
environment = "<add your name>"
aws_region = "us-east-2"

# EMR Configuration
subnet_id = "<subet_id>"
vpc_id = "<vpc_id>"
key_name = "EMR-key-pair"
ingress_cidr_blocks = "0.0.0.0/0"
release_label = "emr-5.30.0"
applications = ["Spark", "Zeppelin", "JupyterHub"]
master_instance_type = "m4.large"
core_instance_type = "m4.large"
core_instance_count = 1

glue_db_name = "datameshcatalogue"

# Lake Formation
lake_formation_admin = "aws-data-mesh-user"

# EKS
cluster_name = "Airflow"
