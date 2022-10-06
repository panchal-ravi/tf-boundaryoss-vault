terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.0.12"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.8.2"
    }
  }
}

provider "vault" {
  address = "http://${module.vault-cluster.vault_ips["public_ip"]}:8200"
  token = trimspace(file("${path.root}/generated_creds/vault-token"))
}

provider "aws" {
  region = var.aws_region
}


provider "boundary" {
  addr             = "http://${module.boundary-cluster.boundary_addr}"
  recovery_kms_hcl = <<EOT
kms "aead" {
    purpose = "recovery"
    aead_type = "aes-gcm"
    key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id = "global_recovery"
}
EOT
}
