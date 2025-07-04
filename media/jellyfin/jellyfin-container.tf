resource "proxmox_virtual_environment_container" "jellyfin-container" {
  node_name = "prox"
  started = true


  memory {
    dedicated = 8192
    swap = 2048
  }

  initialization {
    hostname = "jellyfin-server"

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

    user_account {
        keys = [
		trimspace(tls_private_key.random_ssh_key.public_key_openssh)
	]
	password = random_password.random_user_password.result
    }
  }


     cpu {
      architecture = "amd64"
      cores        = 4
      units        = 2048
     }



  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  network_interface {
    firewall = true
    bridge = "vmbr0"
    name   = "veth0"

  }

  network_interface {
    firewall = true
    bridge = "vmbr1"
    name   = "veth2"
    mac_address = "DE:A4:D1:24:98:FB"
  }

  network_interface {
    bridge      = "pnet1"
    enabled     = true
    firewall    = true
    mac_address = "BC:24:11:54:79:BB"
    mtu         = 0
    name        = "veth1"
    rate_limit  = 0
    vlan_id     = 0
  }

  operating_system {
    #template_file_id = proxmox_virtual_environment_download_file.latest_ubuntu_24_noble_lxc_img.id
    # Or you can use a volume ID, as obtained from a "pvesm list <storage>"
    template_file_id = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"

    type             = "debian"
  }

  mount_point {
          acl           = false
          backup        = false
          mount_options = []
          path          = "/media/nas"
          quota         = false
          read_only     = false
          replicate     = false
          shared        = false
          volume        = "/mnt/sdb1"
        }
}
