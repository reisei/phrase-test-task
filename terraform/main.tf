variable "hcloud_token" {
  sensitive = true # Requires terraform >= 0.14
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "default" {
  name       = "basic_key"
  public_key = file("~/.ssh/hetzner.pub")
}

resource "hcloud_primary_ip" "primary_ip_1" {
  name          = "phrase_test_ip"
  datacenter    = "fsn1-dc14"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "app" : "phrase"
  }
}

resource "hcloud_server" "phrase_test" {
  name        = "test-server"
  image       = "ubuntu-22.04"
  server_type = "cx11"
  datacenter  = "fsn1-dc14"
  ssh_keys    = [hcloud_ssh_key.default.id]
  user_data   = templatefile("user_data.tpl", {
    devops_ssh_key = hcloud_ssh_key.default.public_key
    ansible_ssh_key = hcloud_ssh_key.default.public_key
  })
  labels = {
    "app" : "phrase"
  }
  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.primary_ip_1.id
    ipv6_enabled = false
  }
}
