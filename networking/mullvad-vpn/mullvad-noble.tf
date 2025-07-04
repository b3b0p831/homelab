resource "proxmox_virtual_environment_vm" "mullvad-vpn-ubuntu" {
  name      = "mullvad24.10"
  node_name = "prox"
  started = true


  memory {
    dedicated = 2048
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

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.mullvad_config.id
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 10
  }


   network_device {
     bridge = "inet1"
#     mac_address = "bc:24:45:be:e4:fa"
  }

   network_device {
     bridge = "vmbr0"
#     mac_address = "bc:24:45:be:e4:fa"
  }

   network_device {
     bridge = "pnet1"
#     mac_address = "bc:24:45:a7:f4:ff"
  }

}

