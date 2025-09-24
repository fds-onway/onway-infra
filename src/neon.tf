resource "neon_project" "onway_neon_project" {
  name       = "OnWay"
  pg_version = 15
  region_id  = "aws-sa-east-1"

  org_id = "org-curly-surf-95630868"

  history_retention_seconds = 0

  branch {
    name          = "master"
    database_name = "onway"
    role_name     = "postgres"
  }
}
