terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.76.0"
    }
  }
}


provider "proxmox" {
  endpoint = "https://prox.local:8006"

  # TODO: use terraform variable or remove the line, and use PROXMOX_VE_USERNAME environment variable
  #  username = "root@pam"
  api_token = "root@pam!terraform="

  # because self-signed TLS certificate is in use
  insecure = true

  ssh {
    agent       = false
    private_key = file("/path/to/proxmox_ssh_key")
    username = "root"
  }
}
