provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile = "terraform"
  region     = "us-east-2"
}