resource "random_password" "random_user_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "random_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "random_user_password" {
  value     = random_password.random_user_password.result
  sensitive = true
}

output "random_ssh_private_key" {
  value     = tls_private_key.random_ssh_key.private_key_pem
  sensitive = true
}

output "random_ssh_public_key" {
  value = tls_private_key.random_ssh_key.public_key_openssh
}

resource "proxmox_virtual_environment_download_file" "cloud_image"{
  content_type = "iso"
  datastore_id = "local"
  node_name = "prox"

  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "prox"

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: tailscale-prox
    timezone: America/Los_Angeles
    users:
      - default
      - name: tail
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(tls_private_key.random_ssh_key.public_key_openssh)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - qemu-guest-agent
      - net-tools
      - curl
    runcmd:
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done

    EOF

    file_name="user_data_cloud_config.yaml"

  }
}
