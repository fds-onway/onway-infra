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
    neon = {
      source = "kislerdm/neon"
    }

  }
}

provider "render" {
  api_key  = var.render_api_key
  owner_id = "usr-d2npkkre5dus739ak260"
}

provider "vercel" {
  api_token = var.vercel_api_key
}

provider "neon" {
  api_key = var.neon_api_key
}
