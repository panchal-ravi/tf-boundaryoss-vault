/*
resource "null_resource" "boundary-token" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "remote-exec" {
    inline = [
      "export VAULT_ADDR=http://127.0.0.1:8200",
      "export VAULT_TOKEN=$(cat /home/ubuntu/vault-token)",
      "vault token create -no-default-policy=true -policy=\"boundary-controller\" -policy=\"kv-read\" -policy=\"db-read\" -orphan=true -period=20m -renewable=true -format=json | jq -r '.auth.client_token' > /home/ubuntu/boundary-token",
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${path.root}/private-key/rp-key.pem ubuntu@${var.vault_ip}:/home/ubuntu/boundary-token ./generated_creds/"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = var.vault_ip
    private_key = file("${path.root}/private-key/rp-key.pem")
  }
}
*/

resource "vault_token" "boundary" {
  /* policies = ["boundary-controller", "db-read", "kv-read"] */
  policies = [vault_policy.boundary-controller.name, vault_policy.db-read.name, vault_policy.kv-read.name]

  no_parent = true
  no_default_policy = true
  renewable         = true
  ttl               = "20m"


  metadata = {
    "purpose" = "boundary-service-account"
  }
}


resource "boundary_credential_store_vault" "cred-store" {
  name        = "vault-cred-store"
  description = "Vault credential store!"
  address     = "http://${var.vault_ip}:8200"
  /* token       = trimspace(file("${path.root}/generated_creds/boundary-token")) */
  token       = vault_token.boundary.client_token
  scope_id    = var.project_core_infra_id
  /* 
  depends_on = [
    null_resource.boundary-token
  ] 
  */
}

resource "boundary_credential_library_vault" "vault-ssh-key" {
  name                = "vault-ssh-key"
  description         = "Vault SSH Key"
  credential_store_id = boundary_credential_store_vault.cred-store.id
  path                = "secret/data/backend-sshkey" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "ssh_private_key"
}

resource "boundary_credential_library_vault" "vault-app-secret" {
  name                = "vault-app-secret"
  description         = "Vault application secret"
  credential_store_id = boundary_credential_store_vault.cred-store.id
  path                = "secret/data/app-secret" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_credential_library_vault" "vault-db-secret-dba" {
  name                = "vault-db-secret-dba"
  description         = "Vault Postgres DB secret for DBA role"
  credential_store_id = boundary_credential_store_vault.cred-store.id
  path                = "db/creds/dba"
  http_method         = "GET"
  credential_type     = "username_password"
}

resource "boundary_credential_library_vault" "vault-db-secret-analyst" {
  name                = "vault-db-secret-analyst"
  description         = "Vault Postgres DB secret for Analyst role"
  credential_store_id = boundary_credential_store_vault.cred-store.id
  path                = "db/creds/analyst"
  http_method         = "GET"
  credential_type     = "username_password"
}
