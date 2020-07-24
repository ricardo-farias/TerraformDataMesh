### Background
This repo is used to setup infrastructure for the Spark Practice repository.
In this repo are terraform scripts to construct AWS iam roles, emr cluster, and s3 buckets.


### How to Setup Permissions

Inside of ~/.aws/credentials add your aws access key and secret key.

if the file 'credentials' does not exist, create one.

```
[terraform]
aws_access_key_id=**********
aws_secret_access_key=************
```

This IAM user must have full permissions to:

- VPC
- EMR
- S3
- IAM
- ECR
- ECS
- Glue
- Load Balancer
- Elastic Cache
- SSM

### How to Build
Terraform plan will show all the resources that will be created, run this command:

```shell script
terraform plan
```

To create the resources inside the plan, run this command:

```shell script
terraform apply
```

### How to Deploy a Docker Image to ECR
To build and deploy a working docker image to AWS ECR run the commands below

```shell script
cd airflow
chmod +x /scripts/deploy-to-ecr.sh
./scripts/deploy-to-ecr.sh
```

These command will build and deploy the docker image to ECR. Once the image is uploaded
ECS will automatically start services and tasks for:
 
 - Airflow Webserver
 - Airflow Scheduler
 - Airflow Worker
 
 Redis is created by Terraform

### How to Run Built Docker Image Locally [IN DEVELOPMENT]

To run the docker file image locally, execute the commands below

```shell script
cd airflow

```

### How ro connecto to EKS cluster
Connect
```shell script
aws eks --region us-east-2 update-kubeconfig --name airflow-cluster
```
Check status
```shell script
kubectl config get-contexts
kubectl config current-context
eksctl get cluster -n airflow-cluster
```