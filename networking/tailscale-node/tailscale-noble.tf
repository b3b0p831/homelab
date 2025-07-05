resource "proxmox_virtual_environment_vm" "tailscale-ubuntu-vm" {
  name      = "ubuntu-noble-24.04"
  node_name = "prox"
  started = true


  memory {
    dedicated = 4096
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }


   network_device {
     bridge = "inet1"
  }

   network_device {
     bridge = "pnet1"
  }

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
#     - <Command to init tailscale
      - systemctl enable qemu-guest-agent
      - systemctl start qemu-guest-agent
      - echo "done" > /tmp/cloud-config.done

    EOF

    file_name="user_data_cloud_config.yaml"

  }
}
