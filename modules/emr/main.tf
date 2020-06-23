resource "aws_emr_cluster" "data-mesh-cluster" {
  name          = var.name
  release_label = var.release_label
  applications  = var.applications


  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true



  ec2_attributes {
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group = var.emr_master_security_group
    emr_managed_slave_security_group  = var.emr_slave_security_group
    instance_profile                  = var.emr_ec2_instance_profile
    key_name = var.key_name
  }

  master_instance_group {
    instance_type = var.master_instance_type
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
  }

  ebs_root_volume_size = 10

  log_uri = "s3://${var.logging_bucket}"


  service_role = var.emr_service_role
}