variable "vpc_id" {}

variable "source_ingress_cidrs" {}
variable "source_ami_id" {}
variable "source_associate_public_ip_address" {}
variable "source_availability_zone" {}
variable "source_iam_instance_profile" {}
variable "source_instance_type" {}
variable "source_key_name" {}
variable "source_monitoring" {}
variable "source_root_block_device" {}
variable "source_subnet_id" {}
variable "source_userdata" {}

variable "replica_ingress_cidrs" {}
variable "replica_ami_id" {}
variable "replica_associate_public_ip_address" {}
variable "replica_availability_zone" {}
variable "replica_iam_instance_profile" {}
variable "replica_instance_type" {}
variable "replica_key_name" {}
variable "replica_monitoring" {}
variable "replica_root_block_device" {}
variable "replica_subnet_id" {}
variable "replica_userdata" {}

variable "tags" {}
