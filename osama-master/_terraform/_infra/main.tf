##################################### Provider #####################################
provider "aws" {
  region = var.region
}

##################################### Backend TF-state files   ######################

#terraform {
#  backend "s3" {
#    region = "us-east-1"
#  }
#}
#


#####################################  VPC   #######################################

module "vpc" {
  source = "../_modules/terraform-aws-vpc"

  name        = "vpc"
  environment = var.environment
  label_order = var.label_order
  cidr_block  = var.vpc_cidr
}

#####################################  Subnets   #####################################

module "subnets" {
  source = "../_modules/terraform-aws-subnet"

  name        = "subnets"
  environment = var.environment
  label_order = var.label_order

  nat_gateway_enabled = var.nat_gateway_enabled
  single_nat_gateway  = var.single_nat_gateway

  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  type               = "public-private"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

#####################################  KeyPair   #####################################

module "keypair" {
  source  = "./../_modules/terraform-aws-keypair"

  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmPzqVYDVlaExxJBwbrXT2jG44xMM1U6Z+nCPkjStGj4ayo7Lkz8SzzFbAS0uYaXaTJfc/ZI980BwtLAeWZeaFYDABDROJHS748cTwyByUe1S+yNMrz7wbyeZllQGt6EtnxcOADuMvtBGioTgfXIzJNYb73TlPEUVlTOEDbQd+8oDpO+u7SJFgT+q5OZE5XFyYvp5hHSdLgZhXurRfjvFpqVBwiTojL5o0Q2xqXxTFOFfdoDKcjbMwFwr4vdJ5Edqqa2gcl9nRtCL4vo0m/St0ekbZ3yT9h3gRgP3+u9L0rc0f4XZxNW3b0ljWC1dEd/pAVw1k1y1xRnYKKwNaT6nZcKqFawT/G4S9fj6LrD+RPJsEgMXcIaAcGeidQolVZce4fWyAJc5Dx0ALKTkHNN7NyyTXopuK63YJ5lUEwWOYc6q9l/xM49i9hdpMD0TafqM0rWXFY3ALR9z/U0CMWwtlQ33iInGEYRqd+wupm48nuHII359uNe/GKhjqCLU5K4E= rahul@rahul "
  key_name        = "test1"
  environment     = "gggggg"
  label_order     = var.label_order
  enable_key_pair = var.enable_key_pair #true
}

#####################################  SG   #####################################

module "sg_ssh" {
  source      = "./../_modules/terraform-aws-security-group"

  name        = "ssh"
  environment = var.environment
  label_order = var.label_order
  vpc_id        = module.vpc.vpc_id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [22]
}



#####################################  Ec2   #####################################

module "ec2_kms_key" {
  source                  = "./../_modules/terraform-aws-kms"
  name                    = "ec2-kms"
  environment             = var.environment
  label_order             = var.label_order
  enabled                 = true
  description             = "KMS key for ec2"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/ec3"
  policy                  = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

}

#ec2_php_script2_clone
module "ec2_php_script2_clone" {
  source = "./../_modules/terraform-aws-ec2"
  name        = "ec2-php-script2-clone"
  environment = var.environment
  label_order = var.label_order

  #instance
  instance_enabled = true
  instance_count   = 1
  ami              = "ami-08c40ec9ead489470"
  instance_type    =  var.ec2_php_script2_clone_instance_type #"t2.nano"
  monitoring       = false
  tenancy          = "default"
  hibernation      = false

  #Networking
  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
  subnet_ids                  = tolist(module.subnets.private_subnet_id)
  assign_eip_address          = false
  associate_public_ip_address = false

  #Keypair
  key_name = module.keypair.name

  #IAM
  instance_profile_enabled = false
  iam_instance_profile     = ""

  #Root Volume
  root_block_device = [
    {
      volume_type           = "gp3"
      volume_size           = var.ec2_php_script2_clone_volume_size
      iops                  = 3000
      delete_on_termination = true
      kms_key_id            = module.ec2_kms_key.key_arn

    }

  ]

  #EBS Volume
  ebs_optimized      = false
  ebs_volume_enabled = false

  # Metadata
  metadata_http_tokens_required        = "optional"
  metadata_http_endpoint_enabled       = "enabled"
  metadata_http_put_response_hop_limit = 2

}
#
##ec2_php_scripts_assign
#module "ec2_php_scripts_assign" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-php-scripts-assign"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_php_scripts_assign_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_php_scripts_assign_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
#
#
##ec2_php_scripts_feedback
#module "ec2_php_scripts_feedback" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-php-scripts-feedback"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_php_scripts_feedback_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_php_scripts_feedback_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
#
##ec2_php_scripts_orders
#module "ec2_php_scripts_orders" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-php-scripts-orders"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_php_scripts_orders_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_php_scripts_orders_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
#
#
#
##ec2_qa_app_1click2deliver_com
#module "ec2_qa_app_1click2deliver_com" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-qa-app-1click2deliver-com"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_qa_app_1click2deliver_com_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_qa_app_1click2deliver_com_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
#
#
#
##ec2_scripts
#module "ec2_scripts" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-scripts"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_scripts_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_scripts_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
#
#
#
##ec2_staging
#module "ec2_staging" {
#  source = "./../_modules/terraform-aws-ec2"
#  name        = "ec2-staging"
#  environment = var.environment
#  label_order = var.label_order
#
#  #instance
#  instance_enabled = true
#  instance_count   = 1
#  ami              = "ami-08d658f84a6d84a80"
#  instance_type    =  var.ec2_staging_instance_type #"t2.nano"
#  monitoring       = false
#  tenancy          = "default"
#  hibernation      = false
#
#  #Networking
#  vpc_security_group_ids_list = [module.sg_ssh.security_group_ids]
#  subnet_ids                  = tolist(module.subnets.private_subnet_id)
#  assign_eip_address          = false
#  associate_public_ip_address = false
#
#  #Keypair
#  key_name = module.keypair.name
#
#  #IAM
#  instance_profile_enabled = false
#  iam_instance_profile     = ""
#
#  #Root Volume
#  root_block_device = [
#    {
#      volume_type           = "gp3"
#      volume_size           = var.ec2_staging_volume_size
#      iops                  = 3000
#      delete_on_termination = true
#      kms_key_id            = module.ec2_kms_key.key_arn
#
#    }
#
#  ]
#
#  #EBS Volume
#  ebs_optimized      = false
#  ebs_volume_enabled = false
#
#  # Metadata
#  metadata_http_tokens_required        = "optional"
#  metadata_http_endpoint_enabled       = "enabled"
#  metadata_http_put_response_hop_limit = 2
#
#}
