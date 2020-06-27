resource "digitalocean_droplet" "web" {
    name = "standupbot-db"
    image = "ubuntu-18-04-x64"
    region = "sgp1"
    size = "s-1vcpu-1gb"
    ssh_keys = [var.SSH_KEY]

    provisioner "remote-exec" {
        connection {
            host = self.ipv4_address
            user = "root"
            type = "ssh"
            private_key = file(var.PVT_KEY)
            timeout = "2m"
        }

        inline = [
            "adduser ${var.USERNAME} --disabled-password --gecos ''",
            "echo ${var.USERNAME}:${var.NON_ROOT_PWD} | chpasswd",
            "usermod -aG sudo ${var.USERNAME}",
            "rsync --archive --chown=${var.USERNAME}:${var.USERNAME} ~/.ssh /home/${var.USERNAME}",
            "printf '\n\n===================\nUser ${var.USERNAME} created successfully!\n=================\n\n'"
        ]
    }

    provisioner "remote-exec" {
        connection {
            host = self.ipv4_address
            user = var.USERNAME
            type = "ssh"
            private_key = file(var.PVT_KEY)
            timeout = "2m"
        }

        inline = [
            "echo ${var.NON_ROOT_PWD} | sudo -S apt update -y",
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

    provisioner "remote-exec" {
        connection {
            host = self.ipv4_address
            user = var.USERNAME
            type = "ssh"
            private_key = file(var.PVT_KEY)
            timeout = "2m"
        }

        inline = [
            "echo ${var.NON_ROOT_PWD} | sudo -S apt update -y",
            "sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
            "sudo chmod +x /usr/local/bin/docker-compose",
            "mkdir hasura && cd hasura",
            "wget https://raw.githubusercontent.com/nazmifeeroz/digitalocean-terraform/master/docker-compose.yaml",
            "export ADMIN_SECRET=${var.HASURA_ADMIN_SECRET}",
            "export JWT_SECRET='${var.HASURA_JWT_SECRET}'",
            "echo $ADMIN_SECRET",
            "echo $JWT_SECRET",
            "printf '\n\n===================\n'",
            "sudo -E docker-compose config",
            "printf '\n===================\n\n'",
            "sudo -E docker-compose up -d",
            "printf '\n\n===================\nHasura installed successfully!\n===================\n\n'"
        ]
    }
}

resource "digitalocean_domain" "web" {
    name = var.DOMAIN_NAME
    ip_address = digitalocean_droplet.web.ipv4_address
}

resource "digitalocean_record" "web_record" {
    domain = digitalocean_domain.web.name
    type = "CNAME"
    name = "web-record"
    value = "${digitalocean_domain.web.name}."
}

output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
