#!/bin/bash
yum -y update
yum -y install httpd
# Instance's local IP
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
# Create a simple index.html file
sudo bash -c "echo 'This is web server! IP: $myip' > /var/www/html/index.html"
# Start HTTP server
sudo systemctl start httpd
sudo systemctl enable httpd

