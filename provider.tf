variable "DOMAIN_NAME" {}
variable "DO_PAT" {}
variable "HASURA_ADMIN_SECRET" {}
variable "HASURA_JWT_SECRET" {}
variable "NON_ROOT_PWD" {}
variable "PUB_KEY" {}
variable "PVT_KEY" {}
variable "SSH_KEY" {}
variable "USERNAME" {
    default = "ubuntu"
}

provider "digitalocean" {
    token = var.DO_PAT
}
