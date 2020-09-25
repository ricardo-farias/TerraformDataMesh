### Background

This repo is used to setup AWS infrastructure for datamesh as well as setting up Airflow pipelines to run Spark Jobs for various data products.
___

### Prerequisites 
* Helm Chart
* Kubectl
* Wget

___

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
___

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
___

### Switch kubectl to use newly created EKS Cluster

```shell
aws eks --region us-east-2 update-kubeconfig --name <cluster_name>
kubectl config set-context <eks_cluster_arn>

# Example
# aws eks --region us-east-2 update-kubeconfig --name data-mesh-poc-yourname-cluster
# kubectl config set-context arn:aws:eks:us-east-2:161578411275:cluster/data-mesh-poc-yourname-cluster
```

##### Verify kubectl
```shell
kubectl get nodes
```
___

### Building DAG Docker Images

File to change: `docker/python_aws/controllers/EmrClusterController.py`
- Update `LogUri` with s3 bucket to use for EMR logging (Example: `s3://data-mesh-poc-yourname-emr-data-mesh-logging-bucket`)

File to change: `docker/python_aws/main.py`
- Update `s3_jar_path` (Example: `s3://data-mesh-poc-yourname-emr-configuration-scripts/CitiBikeDataProduct-assembly-0.1.jar`)
- Update `s3_credentials_path` (Example: `s3://data-mesh-poc-yourname-emr-configuration-scripts/credentials`)
- Update `subnet_id` (Example: `subnet-035a65a4ea1d2ed85`)

File to change: `docker/airflow/dags/citi-bike-pipeline.py`
- Update `ecr_image` with your `airflow-ecr-dags-repo-url` from outputs (Example: `161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-airflow-dag-yourname`)

File to change: `docker/airflow/dags/covid-pipeline-pod-operator.py`
- Update `ecr_image` with your `airflow-ecr-dags-repo-url` from outputs (Example: `161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-airflow-dag-yourname`)

####Configure CPU and Memory Allocation for Worker Nodes

Set the KubernetesPodOperator `resources` parameter in the `create_cluster_task` of each data product (ex: citi-bike-pipeline.py and covid-pipeline-pod-operator.py) to allocate cluster resources as needed. 

```python
create_cluster_task = KubernetesPodOperator(namespace='default',
    ...
    resources = {'request_cpu': '0.50', 'request_memory': '0.7Gi'},
    ...
    dag=dag
)
```

File to change: `docker/python_aws/scripts/build-deploy-python-aws.sh`
- Update `REGION` (Example: `us-east-2`)
- Update `ECR_REPO_URL` with your `airflow-ecr-dags-repo-url` from outputs (Example: `161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-airflow-dag-yourname`)

Now run that script to build and deploy DAG Images to AWS ECR...
```shell
./docker/python_aws/scripts/build-deploy-python-aws.sh
```
___

### Building Airflow Docker Image
File to change: `docker/airflow/dags/controllers/EmrClusterController.py`
- Update `LogUri` with s3 bucket to use for EMR logging (Example: `s3://data-mesh-poc-yourname-emr-data-mesh-logging-bucket`)

File to change: `docker/airflow/airflow.cfg`
- Update `remote_base_log_folder` with s3 bucket to use for Airflow logging (Example: `s3://data-mesh-poc-yourname-emr-data-mesh-logging-bucket`)

File to change: `docker/airflow/scripts/build-deploy-airflow.sh`
- Update `REGION` (Example: `us-east-2`)
- Update `ECR_REPO_URL` with your `airflow-ecr-base-repo-url` from outputs (Example: `161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-airflow-base-yourname`)

To build and deploy a working airflow docker image to AWS ECR run following script...
```shell
./docker/airflow/scripts/build-deploy-airflow.sh
```
This command will build and deploy the docker image to ECR. Once the image is uploaded to ECR, you can deploy the airflow to EKS using helm charts. 
___

### Deploying Airflow to EKS using Helm Charts

File to change: `helm/airflow/values.yaml`
- Update `dags_image.repository` with your `airflow-ecr-base-repo-url` from outputs (Example: `161578411275.dkr.ecr.us-east-2.amazonaws.com/data-mesh-poc-airflow-base-yourname`)
- Update `airflow.postgres.host` with your RDS endpoint (Example: `data-mesh-poc-yourname-airflow.ci41jz4lefxv.us-east-2.rds.amazonaws.com`)

File to change: `helm/airflow/templates/secrets.yaml` (Must be base64 encoded values!)
- Update `aws_access_key_id` (Use terminal output of `echo -n "YourAwsAccessKeyId" | base64`)
- Update `aws_secret_access_key` (Use terminal output of `echo -n "YourAwsSecretAccessKey" | base64`)
- Update `POSTGRES_PASSWORD` (Use terminal output of `echo -n "YourPostgresPassword" | base64`)

##### Create Namespaces for Data Products

Namespaces are K8s way of separating cluster resources between different users or products. Create a namespace for each data product to isolate their resources in the cluster.

```
kubectl create namespace citi-bike
kubectl create namespace covid
```

##### Deploying Airflow using Helm Charts

```shell
# Install
helm install datamesh-airflow helm/airflow

# Uninstall
helm uninstall datamesh-airflow
```
___

### Trigger DAG from Airflow UI

```shell
kubectl get services
```
This command should display the EXTERNAL-IP of your airflow cluster. Visit this URL into your browser to open the Airflow UI and trigger your DAG.
___

##Running Airflow Locally with K8s

####Running Terraform Configuration

Open `terraform/main.tf` and remove or comment out the `eks` module (Leave the following modules active: vpc, glue, ecr, iam, rds, s3)

```hcl-terraform
//module "eks" {
//  source = "./modules/eks"
//  subnets = module.vpc.public_subnets
//  vpc_id = module.vpc.vpc_id
//  project_name = var.project_name
//  environment = var.environment
//}
```

Then...
```shell
cd terraform

terraform plan

terraform apply
```
___

####Create Local K8s Cluster using Kind

Install kind - Tool for running K8 Cluster using Docker container

```shell
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.8.1/kind-$(uname)-amd64"
chmod +x ./kind
mv ./kind /usr/local/kind
```

To create a local K8s cluster with a docker registry container, run the following script...
```shell
./kind-with-registry.sh
```
___

File to change: `docker/airflow/dags/citi-bike-pipeline.py`
- Update `ecr_image` with `localhost:5000/python-aws`

File to change: `docker/airflow/dags/covid-pipeline-pod-operator.py`
- Update `ecr_image` with `localhost:5000/python-aws`
---

Build, tag, and push your Airflow image to your cluster's registry by running the following script...
```shell
./docker/airflow/scripts/buildLocal.sh
```
___

Build, tag, and push your DAG image to your cluster's registry by running the following script...
```shell
./docker/python_aws/scripts/buildLocal.sh
```
___

####Deploy PostgreSQL DB in Local K8s Cluster

File to change: helm/airflow/values.yaml
- Change `dags_image.repository` to `localhost:5000/airflow-local`
- Change `airflow.postgres.host` to `postgres-local-postgresql`

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install postgres-local --set postgresqlUsername=airflow,postgresqlPassword=airflow123456,postgresqlDatabase=postgres bitnami/postgresql
```

To save the postgres password of the database you just created as an environment variable...

```shell
export POSTGRES_PASSWORD=$(kubectl get secret --namespace default postgres-local-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
```

Connect to your postgres db to verify that it’s working by running...

```shell
kubectl run postgres-local-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:11.9.0-debian-10-r26 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-local-postgresql -U airflow -d postgres -p 5432
```

You should see the command prompt, `postgres=>` showing you that you’re in the postgres DB. Enter `quit` to exit.

From the root folder in your terminal, run…

```shell
helm install datamesh-airflow helm/airflow
kubectl port-forward svc/airflow 8080:80
```

In a browser, open localhost:8080 to reveal the Airflow UI and trigger the DAG.
