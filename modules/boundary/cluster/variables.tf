variable "owner" {
  description = "owner"
  type        = string
}

variable "instance_type" {
  description = "AWS Instance type"
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "private_subnets" {
  description = "private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "public subnets"
  type        = list(string)
}

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "bastion_ip" {
  type = string
}

variable "rds_hostname" {
  type = string
}

variable "boundary_db_username" {
  type = string
}

variable "boundary_db_password" {
  type = string
}