resource "boundary_user" "backend" {
  for_each    = var.backend_team
  name        = each.key
  description = "Backend user: ${each.key}"
  account_ids = [boundary_account_password.backend_user_acct[each.value].id]
  /* scope_id    = boundary_scope.org.id */
  scope_id    = boundary_scope.global.id
}

resource "boundary_user" "leadership" {
  for_each    = var.leadership_team
  name        = each.key
  description = "WARNING: Managers should be read-only"
  account_ids = [boundary_account_password.leadership_user_acct[each.value].id]
  /* scope_id    = boundary_scope.org.id */
  scope_id    = boundary_scope.global.id
}

resource "boundary_account_password" "backend_user_acct" {
  for_each       = var.backend_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "password"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_account_password" "leadership_user_acct" {
  for_each       = var.leadership_team
  name           = each.key
  description    = "User account for ${each.key}"
  type           = "password"
  login_name     = lower(each.key)
  password       = "password"
  auth_method_id = boundary_auth_method.password.id
}

// organiation level group for the leadership team
resource "boundary_group" "leadership" {
  name        = "leadership_team"
  description = "Organization group for leadership team"
  member_ids  = [for user in boundary_user.leadership : user.id]
  scope_id    = boundary_scope.global.id
}

// project level group for backend and frontend management of core infra
resource "boundary_group" "backend_core_infra" {
  name        = "backend_team"
  description = "Backend team group"
  member_ids  = [for user in boundary_user.backend : user.id]
  scope_id    = boundary_scope.global.id
}

resource "boundary_managed_group" "dba" {
    name = "dba_admin_managed_group"
    description = "DBA Admin managed group"
    auth_method_id = boundary_auth_method_oidc.auth0_oidc.id
    filter = "\"dba_admin\" in \"/userinfo/org-roles\""
}

resource "boundary_managed_group" "analyst" {
    name = "dba_user_managed_group"
    description = "DBA User managed group"
    auth_method_id = boundary_auth_method_oidc.auth0_oidc.id
    filter = "\"dba_user\" in \"/userinfo/org-roles\""
}