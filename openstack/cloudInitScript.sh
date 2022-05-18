#!/bin/bash
# John Doll, cse470g, user script

echo "Running apt update"
apt update
echo "Running apt -y dist-upgrade"
apt -y dist upgrade
echo "Installing nginx"
apt install -y nginx
echo "installing files (clone)"
cd /var/www/html
rm -r *
touch index.html
echo "John Doll" > index.html
date >> index.html
apt install net-tools
ip=$(ifconfig | grep -m 1 "\binet\b" | tr -s ' ' | cut -d ' ' -f 3)
echo $ip >> index.html
uname -a >> index.html
