variable "region" {
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "owner" {
  default = "rp"
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
}

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(any)
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(any)
}

variable "local_privatekey_path" {
  description = "Local path to the private key file"
  type        = string
}
variable "local_privatekey_filename" {
  description = "Private key filename"
  type        = string
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type = string
}

variable "boundary_db_username" {
  type = string
}

variable "boundary_db_password" {
  type = string
}

