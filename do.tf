resource "digitalocean_droplet" "web" {
    name = "standupbot-db"
    image = "ubuntu-18-04-x64"
    region = "sgp1"
    size = "s-1vcpu-1gb"
    ssh_keys = [var.ssh_key]

    provisioner "remote-exec" {
        connection {
            host = self.ipv4_address
            user = "root"
            type = "ssh"
            private_key = file(var.pvt_key)
            timeout = "2m"
        }

        inline = [
            "adduser ${var.user_name} --disabled-password --gecos ''",
            "usermod -aG sudo ${var.user_name}",
            "rsync --archive --chown=${var.user_name}:${var.user_name} ~/.ssh /home/${var.user_name}"
        ]
    }
}

output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
