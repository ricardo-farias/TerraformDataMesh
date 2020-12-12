#!/bin/bash

VIRTUAL_ENV_NAME="DataMeshPoc"
PYTHON_VERSION=3.8.0
DEPENDENCIES=("terraform" "pyenv" "pyenv-virtualenv" "docker" "helm" "kubectl" "wget")

# This function searches for local dependencies on running machine
# If any arent found, then they are installed
function check_for_dependencies_and_install_dependencies(){
  if [ ! -f "/usr/local/bin/brew" ]; then
    echo "Brew must be installed on this machine to proceed, please install brew.."
    exit 1
  fi
  for i in "${!DEPENDENCIES[@]}";
  do
    dependency=${DEPENDENCIES[$i]}
    file="/usr/local/bin/$dependency"
    if [ -f "$file" ]; then
      echo "This dependency was found: $file"
    else
      echo "Installing dependency: $dependency"
      brew install "$dependency"
    fi
  done
}

# This method validates that an aws credential file exists because...
# Terraform requires a credential file
function aws_authentication(){
  file="$HOME/.aws/credentials"
  if [ -f "$file" ]; then
    echo "Credential file found"
  else
    echo "Credential file was not found at: $file"
    exit 1
  fi
}

function create_python_virtual_env(){
  echo "create virtual env"
  file="$HOME/.pyenv/versions/$VIRTUAL_ENV_NAME/"
  if [ -d "$file" ]; then
    echo "Virtual Environment Found $VIRTUAL_ENV_NAME"
  else
    echo "Virtual Environment Not Found $VIRTUAL_ENV_NAME"
    echo "Creating a new virtual environment: $VIRTUAL_ENV_NAME"
    pyenv virtualenv $PYTHON_VERSION $VIRTUAL_ENV_NAME
  fi
}

function modify_tf_vars(){
  printf "Enter a name for all your aws resources: "
  read -r username
  echo "Using this username as part of each resource identity $username"
  sed -i '' -e "s/<add your name>/$username/g" terraform/terraform.tfvars
  printf "Enter your lake formation admin account name: "
  read -r LakeFormationAdmin
  echo "Using Lake Formation Admin: $LakeFormationAdmin"
  sed -i '' -e "s/<lake formation admin goes here>/$LakeFormationAdmin/g" terraform/terraform.tfvars
}

function terraform_apply(){
  cd ./terraform/ || exit
  terraform apply
  terraform output -json > terraform_output.json
#  public_subnet=$(less terraform_output.json | jq ".public_subnets.value[0]")
  rds_endpoint=$(less terraform_output.json | jq ".rds_endpoint.value" | sed -e "s:\"::g")
  base_ecr_image_url=$(less terraform_output.json | jq ".airflow_ecr_base_repo_url.value" | sed "s:\"::g")
#  dag_ecr_image_url=$(less terraform_output.json | jq ".airflow_ecr_dags_repo_url.value" | sed "s:\"::g")

  sed -i '' -e "s:\"<rds_endpoint>\":$rds_endpoint:g" ../helm/airflow/values.yaml
  sed -i '' -e "s:\"<base_ecr_image_url>\":$base_ecr_image_url:g" ../helm/airflow/values.yaml

  rds_password=$(less rds_password.txt | base64)
  sed -i '' -e "s:\"<rds_password>\":$rds_password:g" ../helm/airflow/templates/secrets.yaml
  get_aws_creds "aws_access_key_id="
  aws_access_key_id=$(echo -n "$RETVAL" | base64)
  sed -i '' -e "s:\"<aws_access_key_id>\":$aws_access_key_id:g" ../helm/airflow/templates/secrets.yaml
  get_aws_creds "aws_secret_access_key="
  aws_secret_access_key=$(echo -n "$RETVAL" | base64)
  sed -i '' -e "s:\"<aws_secret_access_key>\":$aws_secret_access_key:g" ../helm/airflow/templates/secrets.yaml
}

function get_aws_creds(){
  RETVAL=""
  while read -r line;
  do
    if [[ $line == *"$1"* ]]; then
      RETVAL=$(echo "$line" | sed "s:$1::g" )
      break
    fi
  done < ~/.aws/credentials
}



function main(){
  check_for_dependencies_and_install_dependencies
  aws_authentication
  create_python_virtual_env
  modify_tf_vars
  terraform_apply
}

main