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


resource "proxmox_virtual_environment_file" "saltmaster_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "prox"

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: salt
    timezone: America/Los_Angeles
    users:
      - default
      - name: master
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(tls_private_key.random_ssh_key.public_key_openssh)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - avahi-daemon
      - net-tools
      - curl
    runcmd:
      - systemctl enable avahi-daemon
      - systemctl restart avahi-daemon
      - mkdir -p /etc/apt/keyrings   
      - curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
      - curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources
      - apt update && apt install salt-master -y
      - systemctl enable salt-master && systemctl start salt-master
      - echo "salty!" > /tmp/cloud-config.done

    EOF

    file_name="saltmaster_config.yaml"

  }
}

resource "proxmox_virtual_environment_file" "saltminion_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "prox"

  source_raw {
    data = <<-EOF
    #cloud-config
    timezone: America/Los_Angeles
    users:
      - default
      - name: gru
        groups:
          - sudo
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(tls_private_key.random_ssh_key.public_key_openssh)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    package_update: true
    packages:
      - net-tools
      - curl
      - wget
      - avahi-utils
    runcmd:
      - mkdir -p /etc/apt/keyrings   
      - curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
      - curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources
      - apt update && apt install salt-minion -y
      - systemctl enable salt-minion && systemctl restart salt-minion
      - mkdir -p /etc/salt/minion.d/
      - 'echo "master: salt.local" > /etc/salt/minion.d/master.conf'
      - 'echo "id: minion-$(uuidgen)" > /etc/salt/minion.d/id.conf'
      - echo "salty!" > /tmp/cloud-config.done

    EOF

    file_name="saltminion_config.yaml"

  }
}