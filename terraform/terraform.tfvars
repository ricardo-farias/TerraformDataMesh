# Project Configuration
project_name = "datamesh"
environment = "rg"
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

glue_db_name = "DataMeshCatalogue"

# S3 Buckets
cluster_name = "Airflow"
error_folder_name = "error/"
raw_folder_name = "raw/"
canonical_folder_name = "canonical/"

# Lake Formation
lake_formation_admin = "aws-data-mesh-user"
