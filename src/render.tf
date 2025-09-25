resource "render_web_service" "onway_api_webservice" {
  name   = "onway-backend"
  plan   = "free"
  region = "oregon"
  start_command = "npm run start:prod"

  runtime_source = {
    native_runtime = {
      auto_deploy         = true
      auto_deploy_trigger = "commit"
      branch              = "main"
      repo_url            = "https://github.com/fds-onway/onway-backend"
      build_command       = "npm install && npm run build"
      runtime             = "node"
    }
  }
}
