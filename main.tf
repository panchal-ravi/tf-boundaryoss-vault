locals {
  deployment_id             = lower("${var.deployment_name}-${random_string.suffix.result}")
  local_privatekey_path     = "${path.root}/private-key"
  local_privatekey_filename = "rp-key.pem"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

provider "random" {}

module "infra-aws" {
  source                    = "./modules/infra/aws"
  region                    = var.aws_region
  owner                     = var.owner
  ttl                       = var.ttl
  deployment_id             = local.deployment_id
  key_pair_key_name         = var.aws_key_pair_key_name
  vpc_cidr                  = var.aws_vpc_cidr
  public_subnets            = var.aws_public_subnets
  private_subnets           = var.aws_private_subnets
  local_privatekey_path     = local.local_privatekey_path
  local_privatekey_filename = local.local_privatekey_filename
  rds_username              = var.rds_username
  rds_password              = var.rds_password
  boundary_db_username      = var.boundary_db_username
  boundary_db_password      = var.boundary_db_password
}

module "boundary-cluster" {
  source               = "./modules/boundary/cluster"
  owner                = var.owner
  deployment_id        = local.deployment_id
  instance_type        = var.aws_instance_type
  key_pair_key_name    = var.aws_key_pair_key_name
  private_subnets      = module.infra-aws.private_subnets
  public_subnets       = module.infra-aws.public_subnets
  vpc_id               = module.infra-aws.vpc_id
  vpc_cidr_block       = module.infra-aws.vpc_cidr_block
  bastion_ip           = module.infra-aws.bastion_ip
  rds_hostname         = module.infra-aws.rds_hostname
  boundary_db_username = var.boundary_db_username
  boundary_db_password = var.boundary_db_password
  depends_on = [
    module.infra-aws
  ]
}

module "boundary-resources" {
  source        = "./modules/boundary/resources"
  boundary_addr = module.boundary-cluster.boundary_addr
  client_id     = var.client_id
  client_secret = var.client_secret

  depends_on = [
    module.boundary-cluster
  ]
}

module "vault-cluster" {
  source            = "./modules/vault/cluster"
  owner             = var.owner
  deployment_id     = local.deployment_id
  instance_type     = var.aws_instance_type
  key_pair_key_name = var.aws_key_pair_key_name
  private_subnets   = module.infra-aws.private_subnets
  public_subnets    = module.infra-aws.public_subnets
  vpc_id            = module.infra-aws.vpc_id
  vpc_cidr_block    = module.infra-aws.vpc_cidr_block
  bastion_ip        = module.infra-aws.bastion_ip
  depends_on = [
    module.boundary-resources
  ]
}

module "vault-resources" {
  source                             = "./modules/vault/resources"
  vault_ip                           = module.vault-cluster.vault_ips["public_ip"]
  boundary_addr                      = module.boundary-cluster.boundary_addr
  org_id                             = module.boundary-resources.org_id
  project_core_infra_id              = module.boundary-resources.project_core_infra_id
  managed_group_dba_id               = module.boundary-resources.managed_group_dba_id
  managed_group_analyst_id           = module.boundary-resources.managed_group_analyst_id
  host_set_static_backend_servers_id = module.boundary-resources.host_set_static_backend_servers_id
  vault_postgres_se_user             = var.vault_postgres_se_user
  vault_postgres_se_password         = var.vault_postgres_se_password
  rds_hostname                       = module.infra-aws.rds_hostname
  depends_on = [
    module.vault-cluster
  ]
}
