#!/bin/bash

VIRTUAL_ENV_NAME="DataMeshPoc"
PYTHON_VERSION=3.8.0
DEPENDENCIES=("terraform" "pyenv" "pyenv-virtualenv" "docker" "helm" "kubectl" "wget")

# uses environment variables:
# TERRAFORM_NAME
# LAKE_FORMATION_ADMIN

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
}

function modify_tf_vars(){
  printf "Enter a name for all your aws resources: "
  read -r username
  export TERRAFORM_NAME="$username"
  echo "$username"
  sed -i '' -e "s/<add your name>/$username/g" terraform/terraform.tfvars
  printf "Enter your lake formation admin account name: "
  read -r LakeFormationAdmin
  export LAKE_FORMATION_ADMIN=$LakeFormationAdmin
  echo "Using Lake Formation Admin: $LakeFormationAdmin"
  sed -i '' -e "s/<lake formation admin goes here>/$LakeFormationAdmin/g" terraform/terraform.tfvars
}

function terraform_apply(){
  echo "terraform apply"
  cd terraform/
  terraform apply
}

function main(){
#  check_for_dependencies_and_install_dependencies
#  aws_authentication
#  create_python_virtual_env
  modify_tf_vars
#  terraform_apply

}

main