output "deployment_id" {
  value = local.deployment_id
}

output "vault_ips" {
  value = module.vault-cluster.vault_ips
}

output "bastion_ip" {
  value = module.infra-aws.bastion_ip
}

output "boundary_controller_ip" {
  value = module.boundary-cluster.boundary_controller_ip
}

output "boundary_worker_ip" {
  value = module.boundary-cluster.boundary_worker_ip
}

output "boundary_addr" {
  value = module.boundary-cluster.boundary_addr
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.infra-aws.rds_hostname
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.infra-aws.rds_port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.infra-aws.rds_username
  sensitive   = true
}
