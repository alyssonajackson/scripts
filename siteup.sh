#!/bin/bash

# author: Alysson Ajackson
# date: Ter Mar  4 20:09:51 BRT 2014
# Version 1: 
#   Create a config file into apache sites available, enable it and create an ref to it into the hosts file

sitename="$1"

test "$sitename" = "" && exit;

sitefolder="/var/www/sites/$sitename"

if [ ! -d "$sitefolder" ]; then
    mkdir "$sitefolder" -p
fi

echo "setting up: $sitename..."

USER="webmaster"

function make_vhost
{
cat <<- _EOF_
	<VirtualHost *:80>
	        ServerAdmin $USER@localhost
	        ServerName $sitename

	        DirectoryIndex index.html index.htm index.php
	        DocumentRoot $sitefolder

	        <Directory />
	                Options Indexes FollowSymLinks MultiViews
	                AllowOverride All
	                Order allow,deny
	                Allow from all
	        </Directory>

	        ErrorLog /tmp/error.log
	        CustomLog /tmp/access.log combined
	</VirtualHost>
_EOF_
}

conf_file="/etc/apache2/sites-available/$sitename.conf"

make_vhost > "$conf_file"
a2ensite "$sitename"

echo "vhost created: http://$sitename"

echo "It works: $sitename" > "$sitefolder/index.html"

echo "127.0.0.1	$sitename" >> /etc/hosts

echo "127.0.0.1	$sitename was added into hosts file"

/etc/init.d/apache2 restart
