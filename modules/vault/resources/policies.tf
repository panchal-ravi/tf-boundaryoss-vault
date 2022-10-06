resource "vault_policy" "boundary-controller" {
  name = "boundary-controller"

  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_policy" "kv-read" {
  name = "kv-read"

  policy = <<EOT
path "secret/data/backend-sshkey" {
  capabilities = ["read"]
}
path "secret/data/app-secret" {
  capabilities = ["read"]
}
EOT
}

resource "vault_policy" "db-read" {
  name = "db-read"

  policy = <<EOT
path "db/creds/dba" {
  capabilities = ["read"]
}
path "db/creds/analyst" {
  capabilities = ["read"]
}
EOT
}