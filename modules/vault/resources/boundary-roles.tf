
resource "boundary_role" "oidc_db_analyst_core_infra" {
  name           = "oidc_db_analyst_core_infra"
  description    = "Access to DB for analyst role"
  scope_id       = var.org_id
  grant_scope_id = var.project_core_infra_id
  grant_strings = [
    "id=${boundary_target.postgres_analyst.id};actions=read,authorize-session",
    "id=*;type=target;actions=list,no-op",
    "id=*;type=auth-token;actions=list,read:self,delete:self"
  ]
  principal_ids = [var.managed_group_analyst_id]
}


resource "boundary_role" "oidc_db_dba_core_infra" {
  name           = "oidc_db_dba_core_infra"
  description    = "Access to DB for dba role"
  scope_id       = var.org_id
  grant_scope_id = var.project_core_infra_id
  grant_strings = [
    "id=${boundary_target.postgres_dba.id};actions=read,authorize-session",
    "id=*;type=target;actions=list,no-op",
    "id=*;type=auth-token;actions=list,read:self,delete:self"
  ]
  principal_ids = [var.managed_group_dba_id]
}
