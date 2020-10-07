# How to setup a develop environment for ECS using a personal AWS account

## Introduction

This repo is used to setup the infrastructure for the Spark Cluster using Amazon ECS.

## Procedure

1. Create a [personal AWS Account](https://aws.amazon.com/)

    The personal AWS account will create the root super user. Save the following credentials in a secure location. They cannot be recovered from AWS once lost:
    - the email address associated with your AWS account
    - the AWS account ID
    - your password
    - your secret access keys

1. Create an [IAM user](https://console.aws.amazon.com/iam/home#/users) named **aws_data_mesh_user**

    1. Click "Add User"
        - Name: aws_data_mesh_user
        - Access type: Programmatic access
    1. Click "Next: Permissions"
        - Select: DataMeshAdministrator
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
    1. Click "Next" and accept defaults until user is created
    1. Copy the "Access key ID", "Secret access key"
        - Download the .csv for safe keeping

1. Install applications

    - Install [AWS CLI](https://aws.amazon.com/cli/)

    ```bash
    brew update
    brew install terraform docker
    terraform init # to initialize Terraform configuration locally for the first time
    ```

    ```bash
    # to generate Fernet key install
    brew install python3
    ln -s -f /usr/local/bin/python3 /usr/local/bin/python
    pip3 install cryptography
    ```

1. Clone the reference Data Mesh repository

    ```bash
    git clone git@github.com:ricardo-farias/TerraformDataMesh.git
    cd TerraformDataMesh
    git checkout tags/ECS-Final -b setup_ecs_personal_aws

    # end of file must be a blank line for unix cli tools to parse them correctly
    git ls-files -z | while IFS= read -rd '' f; do tail -c1 < "$f" | read -r _ || echo >> "$f"; done; git commit --all -m "Add newline to end of every file"
    ```

1. Create the secrets

    ```bash
    # get the exact name including case of the emr-key-pair
    grep -ri emr-key-pair *
    ```

    - Create [AWS EMR Key](https://us-east-2.console.aws.amazon.com/ec2/v2/home?#KeyPairs) using the exact name. Download the .pem file.

    ```bash
    # move the .pem file to the repository root
    mv ~/Downloads/emr-key-pair.pem .

    # save AWS secrets for `aws_data_mesh_user` to user home
    mkdir ~/.aws; cat ~/.aws/credentials <<EOF
    [default]
    aws_access_key_id=<ID for IAM user aws_data_mesh_user>
    aws_secret_access_key=<Secret for IAM user aws_data_mesh_user>

    [profile sparkapp]
    aws_access_key_id=<ID for IAM user aws_data_mesh_user>
    aws_secret_access_key=<Secret for IAM user aws_data_mesh_user>

    [terraform]
    aws_access_key_id=<ID for IAM user aws_data_mesh_user>
    aws_secret_access_key=<Secret for IAM user aws_data_mesh_user>
    EOF

    # create the Fernet key and rds_password
    chmod +x ./terraform-setup.sh; ./terraform-setup.sh;

    # update Docker with the Fernet key
    cat airflow/docker-compose.yml | sed -E "s/FERNET_KEY=.+/FERNET_KEY=$(cat fernet.txt)/" > airflow/docker-compose.yml
    ```

1. AWS S3 Buckets must have globally unique names. Select a unique ID (your initials) to perpend to the bucket names

    ```bash
    BUCKET_PREFIX='aa'

    cat <<EOF > /tmp/replace.sed; chmod +x /tmp/replace.sed
    #!$(which sed) -f
    s/athena-data-mesh-output-bucket/$BUCKET_PREFIX-athena-data-mesh-output-bucket/g
    s/citi-bike-data-bucket/$BUCKET_PREFIX-citi-bike-data-bucket/g
    s/data-mesh-covid-domain/$BUCKET_PREFIX-data-mesh-covid-domain/g
    s/emr-configuration-scripts/$BUCKET_PREFIX-emr-configuration-scripts/g
    s/emr-data-mesh-logging-bucket/$BUCKET_PREFIX-emr-data-mesh-logging-bucket/g
    EOF
    ```

    ```bash
    # for MacOS
    find . -not -path '*/\.*' -type f | xargs -I@ /tmp/replace.sed -i '' "@"; rm  /tmp/replace.sed
    ```

    ```bash
    # for linux
    find . -not -path '*/\.*' -type f | xargs -I@ /tmp/replace.sed -i    "@"; rm  /tmp/replace.sed
    ```

1. Run Terraform. Record the ecr_url

    ```bash
    terraform plan               # to show all the resources that will be created
    echo yes | terraform apply    # to build the cloud infrastructure
    ```

1. Deploy DAGs to AWS

    - copy the ECR URL without the /airflow at the end

    ```bash
    cd airflow
    chmod +x scripts/deploy-to-ecr.sh; scripts/deploy-to-ecr.sh <your ECR_URL>
    ```

## CitiBike Data Product -- Running Airflow on ECR

1. Install applications

    - Install [AWS CLI](https://aws.amazon.com/cli/)

    ```bash
    brew update
    brew install sbt
    ```

1. Clone the reference CitiBike Data Product repository

    ```bash
    git clone git@github.com:ricardo-farias/CitiBikeDataProduct.git
    cd CitiBikeDataProduct
    ```

1. Upload the data to AWS - [https://s3.console.aws.amazon.com/s3/buckets/] . Ensure that $BUCKET_PREFIX is set to your unique ID

    ```bash
    aws s3api create-bucket --bucket $BUCKET_PREFIX-emr-configuration-scripts --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
    chmod +x ./deploy.sh; ./deploy.sh
    aws s3 cp ~/.aws/credentials s3://$BUCKET_PREFIX-emr-configuration-scripts/
    ```

1. Setup the Airflow UI website
    - Goto [ECS Airflow Cluster](https://console.aws.amazon.com/ecs/home?#/clusters/Airflow/services/Airflow-Webserver/tasks) on your AWS console.
    - Open up the Task by clicking on it.
    - Copy the Public IP address and open it up in a new browser window by appending `:8080` to it. eg: `18.216.128.196:8080`
    - Click on Admin > Variables. Add `aws_access_key_id` and `aws_secret_access_key`. (see `~/.aws/credentials` section `profile sparkapp`)
    - Click on the `Dags` tab. Click on the `citi-bike-pipeline` list item. Push `Trigger Dag` to run the DAG
