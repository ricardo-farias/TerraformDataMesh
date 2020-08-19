# EMR general configurations
name = "Data Mesh Cluster"
region = "us-east-2"
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
athena_bucket_name = "athena-data-mesh-output-bucket"
data_bucket_name = "data-mesh-covid-domain"
logging_bucket_name = "emr-data-mesh-logging-bucket"
cluster_name = "Airflow"