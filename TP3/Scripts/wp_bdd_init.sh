#!/usr/bin/env bash

sudo apt -y update && apt -y upgrade
sudo apt -y install mariadb-server && apt install -y mariadb-client

sudo mysql -e "CREATE DATABASE wordpress CHARACTER SET UTF8 COLLATE UTF8_BIN"
sudo mysql -e "CREATE USER 'wp-user'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO wp-user@192.168.77.20 IDENTIFIED by 'password'"
sudo mysql -e "FLUSH PRIVILEGES"
sudo mysql -e "EXIT"
sudo sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb.service

touch /tmp/cloud-init-ok