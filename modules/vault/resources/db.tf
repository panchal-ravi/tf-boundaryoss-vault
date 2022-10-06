resource "vault_mount" "db" {
  path = "db"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = "postgres"
  allowed_roles = ["dba", "analyst"]

  postgresql {
    connection_url = "postgres://${var.vault_postgres_se_user}:${var.vault_postgres_se_password}@${var.rds_hostname}/postgres"
  }
}

resource "vault_database_secret_backend_role" "role_dba" {
  backend             = vault_mount.db.path
  name                = "dba"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT dba TO \"{{name}}\";"]
  default_ttl         = 300
  max_ttl             = 3600
}

resource "vault_database_secret_backend_role" "role_analyst" {
  backend             = vault_mount.db.path
  name                = "analyst"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT analyst TO \"{{name}}\";"]
  default_ttl         = 300
  max_ttl             = 3600
}