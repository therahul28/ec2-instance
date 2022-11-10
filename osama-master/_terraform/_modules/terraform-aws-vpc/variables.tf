#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

#Module      : VPC
#Description : Terraform VPC module variables.
variable "vpc_enabled" {
  type        = bool
  default     = true
  description = "Flag to control the vpc creation."
}

variable "restrict_default_sg" {
  type        = bool
  default     = true
  description = "Flag to control the restrict default sg creation."
}

variable "cidr_block" {
  type        = string
  default     = ""
  description = "CIDR for the VPC."
}

variable "additional_cidr_block" {
  type        = list(string)
  default     = []
  description = "	List of secondary CIDR blocks of the VPC."
}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "A tenancy option for instances launched into the VPC."
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC."
}

variable "enable_classiclink" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable ClassicLink for the VPC."
}

variable "enable_classiclink_dns_support" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC."
}

#Module      : FLOW LOG
#Description : Terraform flow log module variables.
variable "enable_flow_log" {
  type        = bool
  default     = false
  description = "Enable vpc_flow_log logs."
}

variable "s3_bucket_arn" {
  type        = string
  default     = ""
  description = "S3 ARN for vpc logs."
  sensitive   = true
}

variable "traffic_type" {
  type        = string
  default     = "ALL"
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL."
}

variable "ipv4_ipam_pool_id" {
  type        = string
  default     = ""
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."

}

variable "ipv4_netmask_length" {
  type        = string
  default     = null
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id"
}

variable "default_security_group_ingress" {
  type        = list(map(string))
  default     = []
  description = "List of maps of ingress rules to set on the default security group"
}

variable "default_security_group_egress" {
  type        = list(map(string))
  default     = []
  description = "List of maps of egress rules to set on the default security group"
}

variable "enable_dhcp_options" {
  type        = bool
  default     = false
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
}

variable "dhcp_options_domain_name" {
  type        = string
  default     = ""
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_domain_name_servers" {
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_ntp_servers" {
  type        = list(string)
  default     = []
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_netbios_name_servers" {
  type        = list(string)
  default     = []
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
}

variable "dhcp_options_netbios_node_type" {
  type        = string
  default     = ""
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
}


variable "enabled_ipv6_egress_only_internet_gateway" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable IPv6 Egress-Only Internet Gateway creation"
}
