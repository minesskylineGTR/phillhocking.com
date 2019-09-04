resource "aws_instance" "ghost" {
  ami                     = "${data.aws_ami.ubuntu.id}"
  instance_type           = "t2.small"
  key_name                = "${var.key_pair_name}"
  vpc_security_group_ids  = "${var.security_groups}"

  tags = {
    Name = "ghost-server"
  }

  lifecycle {
    ignore_changes  = ["ami"]
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "50"
    delete_on_termination = "false"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -",
      "sudo apt-get install -y unzip nginx nginx-full nodejs",
      "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -",
      "echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | sudo tee /etc/apt/sources.list.d/yarn.list",
      "sudo apt-get update && sudo apt-get install yarn",
    ]

    connection  {
      host          = "${self.public_ip}"
      type          = "ssh"
      user          = "ubuntu"
      private_key   = "${file("${var.key_pair_location}")}"
    }

    on_failure = "fail"
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://ghost.org/zip/ghost-latest.zip",
      "sudo apt-get install unzip",
      "sudo unzip -d /var/www/ghost ghost-latest.zip",
      "cd /var/www/ghost/",
      "sudo yarn install --production",
      "sleep 1"
    ]

    connection {
      host          = "${self.public_ip}"     
      type          = "ssh"
      user          = "ubuntu"
      private_key   = "${file("${var.key_pair_location}")}"
    }

    on_failure = "fail"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chown -R ubuntu:ubuntu /var/www/ghost/",
      "cat <<FILEXXX > /var/www/ghost/core/server/config/env/config.production.json",
      "${data.template_file.ghost-config.rendered}",
      "FILEXXX",
      "cd /var/www/ghost/",
      "yarn global add knex-migrator",
      "NODE_ENV=production yarn run knex-migrator init",
      "sleep 1",
    ]

    connection {
      host          = "${self.public_ip}"
      type          = "ssh"
      user          = "ubuntu"
      private_key   = "${file("${var.key_pair_location}")}"
    }

    on_failure = "fail"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --disabled-password --shell /bin/bash --gecos 'Ghost application' ghost",
      "sudo chown -R ghost:ghost /var/www/ghost/",
      "sudo touch /etc/nginx/sites-available/ghost && sudo chown ubuntu:ubuntu /etc/nginx/sites-available/ghost",
      "sudo touch /etc/systemd/system/ghost.service && sudo chown ubuntu:ubuntu /etc/systemd/system/ghost.service",
      "cat <<FILEXXX > /etc/nginx/sites-available/ghost",
      "${data.template_file.nginx-site-config.rendered}",
      "FILEXXX",
      "sudo cat <<FILEXXX > /etc/systemd/system/ghost.service",
      "${data.template_file.service-config.rendered}",
      "FILEXXX",
      "sudo ln -s /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost",
      "sudo rm /etc/nginx/sites-enabled/default",
      "sudo systemctl enable ghost.service",
      "sudo systemctl start ghost.service",
      "sudo service nginx restart",
      "sleep 1",
    ]

    connection {
      host          = "${self.public_ip}"
      type          = "ssh"
      user          = "ubuntu"
      private_key   = "${file("${var.key_pair_location}")}"
    }

    on_failure = "fail"
  }
}
