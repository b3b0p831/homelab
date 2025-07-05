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
        address = "192.168.0.33/24"
        gateway = "192.168.0.1"
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
     bridge = "vmbr1"
  }


   network_device {
     bridge = "inet1"
  }

}
