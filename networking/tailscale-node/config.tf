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
