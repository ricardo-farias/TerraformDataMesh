### Background

This repo is used to setup AWS infrastructure for datamesh as well as setting up Airflow pipelines to run Spark Jobs for various data products.

### Prerequisites 
* Helm Chart
* Kubectl
* Wget

### How to Setup Permissions
Inside of `~/.aws/credentials` add your aws access key and secret key.

If the file 'credentials' does not exist, create one.

```
[default]
aws_access_key_id=**********
aws_secret_access_key=************

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

### Verify kubectl
```shell
kubectl get nodes
```

### Building DAG Images 
Under `docker/airflow/dags/citi-bike-pipeline.py`, update reference to `ecr_image` with your ecr_url from the AWS Console.

Under `docker/python_aws/main.py`, update reference to `s3_jar_path` , `s3_credentials_path` and `subnet_id` 

To build and deploy DAG Image to AWS ECR, update the `ECR_URL` and `REGION` on the script file `build-deploy-python-aws.sh` and run following script

```shell
./docker/python_aws/scripts/build-deploy-python-aws.sh
```

### Building Airflow Docker Image

Under `docker/airflow/scripts/build-deploy-airflow.sh` update the `REGION` and replace the value of `ECR_REPO_URL` with your ecr_url from the AWS Console. To build and deploy a working airflow docker image to AWS ECR run following script

```shell
./docker/airflow/scripts/build-deploy-airflow.sh
```

This command will build and deploy the docker image to ECR. Once the image is uploaded to ECR, you can deploy the airflow  to EKS using helm charts

### Deploying Airflow to EKS

Under `helm/airflow/values.yaml`, update values for

* `dags_image.repository`
* `airflow.postgres.host`

Under `helm/airflow/templates/secrets.yaml`, update values for

* `aws_access_key_id`
* `aws_secret_access_key`
* `POSTGRES_PASSWORD`

### Create namespaces for Data Products

```
kubectl create namespace citi-bike
kubectl create namespace covid
```

### Deploying Airflow using Helm Charts

```shell
# Install
helm install datamesh-airflow helm/airflow

# Uninstall
helm uninstall datamesh-airflow
```

### Trigger DAG from Airflow UI

```shell
kubectl get services
```
This command should display the EXTERNAL-IP of your airflow cluster. Visit this URL into your browser to open the Airflow UI and trigger your DAG.
