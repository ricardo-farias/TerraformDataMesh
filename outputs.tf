//output "id" {
//  value = module.emr.id
//}
//
//output "name" {
//  value = module.emr.name
//}
//
//output "master_public_dns" {
//  value = module.emr.master_public_dns
//}

output "public_subnet-1" {
  value = module.security.public_subnet_1_id
}

output "public_subnet-2" {
  value = module.security.public_subnet_2_id
}