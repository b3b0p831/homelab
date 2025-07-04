# Saltyfleet

**Saltyfleet** is a SaltStack lab environment built using Terraform.

This project automates the creation of a Salt master and multiple Salt minion virtual machines (VMs). Once deployed, all minions will automatically connect to the Salt master at salt.local.

## Getting Started

1. Clone the repository
2. Navigate to the saltyfleet directory
3. Make any neccesary changes (i.e cloud-init configs, network interfaces, etc)
4. Run terraform init and terraform apply to deploy the infrastructure
5. Get salty
