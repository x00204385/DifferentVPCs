#!/bin/bash
sudo apt update -y
sudo apt install -y apache2 
sudo a2enmod rewrite
sudo apt install -y php libapache2-mod-php 
sudo cp /home/ubuntu/index.php /var/www/html/index.php
sudo mv /var/www/html/index.html /var/www/html/index.html.bak
sudo systemctl restart apache2
