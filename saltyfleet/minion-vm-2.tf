resource "proxmox_virtual_environment_vm" "saltstack-minion-2" {
  name      = "saltminion-24.04-2"
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

    user_data_file_id = proxmox_virtual_environment_file.saltminion_config.id
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
     bridge = "pnet1"
  }

}
