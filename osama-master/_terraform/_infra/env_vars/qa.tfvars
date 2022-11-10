#provider
region = "us-east-1"

#lables
environment = "qa"
label_order = ["name", "environment"]


#Networking
vpc_cidr            = "10.20.0.0/16"
nat_gateway_enabled = false
single_nat_gateway  = true
availability_zones  = ["us-east-1a", "us-east-1b"]

#EC2
#php_script2_clone
ec2_php_script2_clone_instance_type = "m5.xlarge"
ec2_php_script2_clone_volume_size  = 50

#php_scripts_assign
ec2_php_scripts_assign_instance_type = "m5.xlarge"
ec2_php_scripts_assign_volume_size  = 50

#php_scripts_feedback
ec2_php_scripts_feedback_instance_type  = "m5.xlarge"
ec2_php_scripts_feedback_volume_size    = 50

#ec2_php_scripts_orders
ec2_php_scripts_orders_instance_type  ="m5.xlarge"
ec2_php_scripts_orders_volume_size    =  50

#ec2_qa_app_1click2deliver_com
ec2_qa_app_1click2deliver_com_instance_type = "m5.xlarge"
ec2_qa_app_1click2deliver_com_volume_size   = 50

#ec2_scripts
ec2_scripts_instance_type = "m5.xlarge"
ec2_scripts_volume_size   = 50

#ec2_staging
ec2_staging_instance_type = "m5.xlarge"
ec2_staging_volume_size   = 50