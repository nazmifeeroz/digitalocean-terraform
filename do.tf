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
            "echo ${var.user_name}:${var.pw} | chpasswd",
            "usermod -aG sudo ${var.user_name}",
            "rsync --archive --chown=${var.user_name}:${var.user_name} ~/.ssh /home/${var.user_name}",
            "printf '\n\n===================\nUser ${var.user_name} created successfully!\n===================\n\n'"
        ]
    }

    provisioner "remote-exec" {
        connection {
            host = self.ipv4_address
            user = var.user_name
            type = "ssh"
            private_key = file(var.pvt_key)
            timeout = "2m"
        }

        inline = [
            "echo ${var.pw} | sudo -S apt update -y",
            "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
            "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable'",
            "sudo apt update -y",
            "apt-cache policy docker-ce",
            "sudo apt install docker-ce -y",
            "sudo systemctl status docker --no-pager",
            "printf '\n\n===================\nDocker installed successfully!\n===================\n\n'"
        ]
    }
}

output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
