terraform {
  required_providers {
    render = {
      version = "~> 1.7.5"
      source  = "render-oss/render"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}
