resource "boundary_host_catalog_static" "db_servers" {
  name        = "db_servers"
  description = "DB servers"
  scope_id    = var.project_core_infra_id
}

resource "boundary_host_static" "db_servers" {
  name            = "postgres_db_server"
  description     = "Postgres DB server"
  address         = var.rds_hostname
  host_catalog_id = boundary_host_catalog_static.db_servers.id
}

resource "boundary_host_set_static" "db_servers" {
  name            = "db_servers"
  description     = "Host set for DB servers"
  host_catalog_id = boundary_host_catalog_static.db_servers.id
  host_ids        = [boundary_host_static.db_servers.id]
}

