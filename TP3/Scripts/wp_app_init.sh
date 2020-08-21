#!/usr/bin/env bash

sudo apt -y update && apt -y upgrade
sudo apt install apache2
sudo apt install php php-mysql

cd /tmp && wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
sudo cp -R wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/
sudo mkdir /var/www/html/wordpress/wp-content/uploads
sudo chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/
cd /var/www/html/wordpress
mv wp-config-sample.php wp-config.php
sed -i -e "s/database_name_here/wordpress/g" wp-config.php 
sed -i -e "s/username_here/wp-user/g" wp-config.php 
sed -i -e "s/password_here/password/g" wp-config.php 
sed -i -e "s/localhost/192.168.10.30:3306/g" wp-config.php 
sudo systemctl restart apache2

touch /tmp/cloud-init-ok