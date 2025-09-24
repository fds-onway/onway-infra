output "database_endpoint" {
  value = neon_project.onway_neon_project.database_host
}

output "database_password" {
  value     = neon_project.onway_neon_project.database_password
  sensitive = true
}
