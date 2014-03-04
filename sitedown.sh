#!/bin/bash

# author: Alysson Ajackson
# date Ter Mar  4 20:08:41 BRT 2014
# Version 1: 
#   Delete a site from apache config and remove its reference from the hosts file

sitename="$1"

test "$sitename" = "" && exit;

echo "shutting down: $sitename..."

a2dissite "$sitename"

#rm -f /etc/apache2/sites-available/$sitename
#rm -f /etc/apache2/sites-enabled/$sitename

echo "Site was removed: http://$sitename"

sitefolder="/var/www/sites/$sitename"

if test "$2" = "--del" && test -d "$sitefolder"
then
    rm "$sitefolder" -rf
    echo "Directory was deleted: $sitefolder"
fi

sed --in-place "/^.*$sitename$/d" /etc/hosts

/etc/init.d/apache2 restart
