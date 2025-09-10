terraform {
  required_providers {
    render = {
      version = "~> 1.7.5"
      source  = "render-oss/render"
    }
    vercel = {
      version = "~> 3.15.1"
      source  = "vercel/vercel"
    }
  }
}

provider "render" {
  api_key = var.render_api_key
}

provider "vercel" {
  api_token = var.vercel_api_key
}
