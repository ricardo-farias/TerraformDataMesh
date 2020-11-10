##########################
# Platform Shared Repo URI
##########################
output "platform-shared-ecr-repo-url" {
   value = aws_ecr_repository.platform-shared.repository_url
 }

########################
# Covid Product Repo URI
########################
 output "covid-ecr-repo-url" {
   value = aws_ecr_repository.covid.repository_url
 }

############################
# Citi-bike Product Repo URI
############################
 output "citi-bike-ecr-repo-url" {
   value = aws_ecr_repository.citi-bike.repository_url
 }


