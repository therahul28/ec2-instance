##################################### provider #####################################

variable "region" {

}

##################################### labels #####################################
variable "environment" {

}

variable "label_order" {

}

##################################### networking #####################################

variable "vpc_cidr" {}
variable "nat_gateway_enabled" {}
variable "single_nat_gateway" {}
variable "availability_zones" {}
##################################### key_pair #####################################


#variable "public_key" {
#
#}

variable "enable_key_pair" {
default = true
}

##################################### EC2 #####################################
#php_script2_clone
variable "ec2_php_script2_clone_instance_type" {}
variable "ec2_php_script2_clone_volume_size" {}

#php_scripts_assign
variable "ec2_php_scripts_assign_instance_type" {}
variable "ec2_php_scripts_assign_volume_size" {}

#php_scripts_feedback
variable "ec2_php_scripts_feedback_instance_type" {}
variable "ec2_php_scripts_feedback_volume_size" {}

#ec2_php_scripts_orders
variable "ec2_php_scripts_orders_instance_type" {}
variable "ec2_php_scripts_orders_volume_size" {}

#ec2_qa_app_1click2deliver_com
variable "ec2_qa_app_1click2deliver_com_instance_type" {}
variable "ec2_qa_app_1click2deliver_com_volume_size" {}

#ec2_scripts
variable "ec2_scripts_instance_type" {}
variable "ec2_scripts_volume_size" {}

#ec2_staging
variable "ec2_staging_instance_type" {}
variable "ec2_staging_volume_size" {}


###################################### eks #####################################
#
#
#variable "enable_eks" {
#
#}
#
#variable "kubernetes_version" {
#
#}
#
#variable "endpoint_private_access" {
#
#}
#
#variable "endpoint_public_access" {
#
#}
#
#variable "enabled_cluster_log_types" {
#
#}
#
#variable "oidc_provider_enabled" {
#
#}
#
#variable "allowed_cidr_blocks" {
#
#}
#
#variable "block_device_mappings" {
#
#}
#
#variable "managed_node_group" {
#
#}
#
#variable "map_additional_iam_roles" {
#
#}

#
###################################### autosalling #####################################
### Autoscaler_vpp ##
#variable "vpp_maxsize" {
#
#}
#
#variable "vpp_minsize" {
#
#}
#
### Autoscaler_srg ##
#
#
#variable "srg_maxsize" {
#
#}
#
#variable "srg_minsize" {
#
#}
#
### Autoscaler_platform ##
#variable "platform_maxsize" {
#
#}
#
#variable "platform_minsize" {
#}
#
#
### Autoscaler_sites ##
#variable "sites_maxsize" {
#
#}
#
#variable "sites_minsize" {
#
#}
#
###################################### ecr #####################################
#
#
#variable "scan_on_push" {
#
#}
#
###################################### aurora_postgresql #####################################
#
#
#variable "create_cluster" {
#
#}
#
#variable "database_name" {
#
#}
#
#variable "master_username" {
#
#}
#
#variable "master_password" {
#
#}
#
#variable "monitoring_interval" {
#
#}
#
#variable "apply_immediately" {
#
#}
#
#variable "skip_final_snapshot" {
#
#}
#
#variable "scaling_configuration" {
#
#}
#
#variable "storage_encrypted" {
#
#}
#
#variable "engine" {
#
#}
#
#variable "engine_mode" {
#
#}