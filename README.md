# homelab IaC

![proxmox homelab](imgs/homelab)

A collection of terraform IaC that makes up my current proxmox homelab.

Each subproject contains its own `README.md` with setup instructions. To get started, navigate into the respective directory and follow the provided guide.

## Table of Contents

### 🧪 Labs

* [`saltyfleet`](labs/saltyfleet/) – A SaltStack lab environment built with Terraform. Automatically deploys a Salt master and serveral minion VMs.

### 🌐 Networking

* [`tailscale-node`](networking/tailscale-node/) – Automates the configuration of a node to join your [Tailscale](https://tailscale.com/) network.
* [`mullvad`](networking/tailscale-node/) – Automates the configuration of a mullvad-vpn client. Would like to setup routing to provide VPN access to proxmox machines.

### 🎬 Media

* [`jellyfin`](media/jellyfin-server/) – Sets up a [Jellyfin](https://jellyfin.org/) media server that mounts my media library.
