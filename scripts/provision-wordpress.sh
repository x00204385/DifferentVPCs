#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
sudo apt install -y php libapache2-mod-php php-mysql
sudo apt install -y mysql-server
sudo apt install -y nfs-common
wget https://wordpress.org/latest.tar.gz
sudo tar xf latest.tar.gz -C /var/www/html
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
cd /var/www/html/wordpress
sudo sed -i 's/database_name_here/wp/g' wp-config.php
sudo sed -i 's/username_here/wp_user/g' wp-config.php
sudo sed -i 's/password_here/Computing1/g' wp-config.php
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
