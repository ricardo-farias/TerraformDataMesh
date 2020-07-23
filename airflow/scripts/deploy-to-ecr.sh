if [ $# -gt 0 ]; then

  aws_account_location=$1

  aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin "${aws_account_location}"
  docker build -t airflow .
  docker tag airflow:latest "${aws_account_location}"/airflow:latest
  docker push "${aws_account_location}"/airflow:latest

else
  echo "Must provide an aws location: ***********.dkr.ecr.us-east-2.amazonaws.com"

fi