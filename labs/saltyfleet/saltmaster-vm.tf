resource "proxmox_virtual_environment_vm" "saltstack-master" {
  name      = "saltmaster-24.04"
  node_name = "prox"
  started = true


  memory {
    dedicated = 1024
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


    user_data_file_id = proxmox_virtual_environment_file.saltmaster_config.id
  }

  disk {
    datastore_id = "local-lvm"

#    file_id      = proxmox_virtual_environment_download_file.cloud_image.id
    file_id      = "local:iso/noble-server-cloudimg-amd64.img"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 10
  }


   network_device {
     bridge = "vmbr0"
  }


   network_device {
     bridge = "pnet1"
  }

}
