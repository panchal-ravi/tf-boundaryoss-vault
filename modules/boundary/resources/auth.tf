resource "boundary_auth_method" "password" {
  name                 = "Password Authentication"
  description          = "Password auth method for Global"
  type                 = "password"
  scope_id             = boundary_scope.global.id
}

resource "boundary_auth_method_oidc" "auth0_oidc" {
  scope_id             = boundary_scope.org.id
  name                 = "OIDC Authentication"
  description          = "OIDC auth method for Corp org"
  type                 = "oidc"
  issuer               = "https://dev-yozmemkp.us.auth0.com/"
  client_id            = "${var.client_id}"
  client_secret        = "${var.client_secret}"
  callback_url         = "http://${var.boundary_addr}/v1/auth-methods/oidc:authenticate:callback"
  api_url_prefix       = "http://${var.boundary_addr}"
  signing_algorithms   = ["RS256"]
  is_primary_for_scope = true
  max_age              = 0
}
