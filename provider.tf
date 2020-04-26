variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_key" {}
variable "user_name" {}

provider "digitalocean" {
    token = var.do_token
}
