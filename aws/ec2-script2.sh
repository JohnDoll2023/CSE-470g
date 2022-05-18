#!/bin/bash
#! John Doll, cse470, cloud init script 2

apt update
apt -y dist-upgrade
apt install -y nginx
rm -rf /var/www/html
cd /var/www
echo "running git clone"
git clone https://gitlab.csi.miamioh.edu/campbest/cse470g-web1.git html

cd html

sed -i 's/campbest/dolljm/' index.html
sed -i 's/Scott Campbell/John Doll/' index.html
sed -i 's/Simple Site/&\n<div class="site">This is SITE 2<\/div>/' index.html
sed -i '/<\/body>/ s/^/<div class="footer">CSE470g<\/div>/' index.html
