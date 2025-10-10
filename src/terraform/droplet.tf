resource "tls_private_key" "onway_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "onway_ssh_key" {
  name       = "Neon Instance Key"
  public_key = tls_private_key.onway_key.public_key_openssh
}

resource "digitalocean_droplet" "onway_droplet" {
  name = "onway-droplet"

  image    = "debian-12-x64"
  size     = "s-1vcpu-512mb-10gb"
  region   = "nyc1"
  ssh_keys = [digitalocean_ssh_key.onway_ssh_key.id]

  lifecycle {
    ignore_changes = [name]
  }
}

resource "local_sensitive_file" "private_key_pem" {
  content  = tls_private_key.onway_key.private_key_pem
  filename = "${path.module}/../ansible/server_key.pem"
}
