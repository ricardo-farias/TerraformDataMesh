### Background

This repo is used to setup AWS infrastructure for datamesh as well as setting up Airflow pipelines to run Spark Jobs for various data products.


### How to Setup Permissions
Inside of `~/.aws/credentials` add your aws access key and secret key.

If the file 'credentials' does not exist, create one.

```
[terraform]
aws_access_key_id=**********
aws_secret_access_key=************
```

### Running Terraform Configuration

Open `terraform/main.tf` and make sure the following modules are active: vpc, glue, ecr, iam, rds, eks, s3

In `terraform/terraform.tfvars` replace the `project_name` and `environment` value with your own unique values. 

```shell
cd terraform

# Initializing Terraform Providers
terraform init

# Getting Terraform Plan
terraform plan

# Applying Terraform Plan
terraform apply
```

### Switch kubectl to use newly created EKS Cluster

```shell
aws eks --region us-east-2 update-kubeconfig --name <cluster_name>
kubectl config set-context <eks_cluster_arn>

# Example
# aws eks --region us-east-2 update-kubeconfig --name data-mesh-poc-aayush-cluster
# kubectl config set-context arn:aws:eks:us-east-2:161578411275:cluster/data-mesh-poc-aayush-cluster
```

### Building Airflow Docker Image

Under `docker/airflow/scripts/build-deploy-airflow.sh` update the `REGION` and replace the value of `ECR_URL` with your ecr_url from the AWS Console. To build and deploy a working airflow docker image to AWS ECR run following script

```shell
./docker/airflow/scripts/build-deploy-airflow.sh
```

This command will build and deploy the docker image to ECR. Once the image is uploaded to ECR, you can deploy the airflow pipeline to EKS using helm

### Building DAG Images 

Under `docker/python_aws/main.py`, update reference to `s3_jar_path` , `s3_credentials_path` and `subnet_id` 

To build and deploy DAG Image to AWS ECR, update the `ECR_URL` and `REGION` on the script file and run following script

```shell
./docker/python_aws/scripts/build-deploy-python-aws.sh
```

### Deploying Airflow to EKS

Under `helm/airflow/values.yaml`, update values for

* `dags_image.repository`
* `airflow.postgres.host`

Under `helm/airflow/templates/secrets.yaml`, update values for

* `aws_access_key_id`
* `aws_secret_access_key`


Perform helm install using

```shell
helm install datamesh-airflow helm/airflow
```

