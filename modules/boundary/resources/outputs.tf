output "project_core_infra_id" {
  value = boundary_scope.core_infra.id
}

output "org_id" {
  value = boundary_scope.org.id
}


output "host_set_static_backend_servers_id" {
  value = boundary_host_set_static.backend_servers.id
}


output "managed_group_analyst_id" {
  value = boundary_managed_group.analyst.id
}

output "managed_group_dba_id" {
  value = boundary_managed_group.dba.id
}
