output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}


output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.this.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.this.username
  sensitive   = true
}