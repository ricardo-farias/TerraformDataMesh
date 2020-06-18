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

### How to Build
Terraform plan will show all the resources that will be created, run this command:

```shell script
terraform plan
```

To create the resources inside the plan, run this command:

```shell script
terraform apply
```
