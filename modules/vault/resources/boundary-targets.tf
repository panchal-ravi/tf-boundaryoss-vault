resource "boundary_target" "backend_servers_injected_ssh" {
  type                     = "tcp"
  name                     = "backend_servers_injected_ssh"
  description              = "Backend SSH target with injected key"
  scope_id                 = var.project_core_infra_id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    var.host_set_static_backend_servers_id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.vault-app-secret.id
  ]
  /* injected_application_credential_source_ids = [
    boundary_credential_library_vault.vault-ssh-key.id
  ] */
}

resource "boundary_target" "postgres_dba" {
  type                     = "tcp"
  name                     = "postgres_dba"
  description              = "Postgres DB target for DBA"
  scope_id                 = var.project_core_infra_id
  session_connection_limit = -1
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.db_servers.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.vault-db-secret-dba.id
  ]
}

resource "boundary_target" "postgres_analyst" {
  type                     = "tcp"
  name                     = "postgres_analyst"
  description              = "Postgres DB target for Analyst"
  scope_id                 = var.project_core_infra_id
  session_connection_limit = -1
  default_port             = 5432
  host_source_ids = [
    boundary_host_set_static.db_servers.id
  ]
  brokered_credential_source_ids = [
    boundary_credential_library_vault.vault-db-secret-analyst.id
  ]
}