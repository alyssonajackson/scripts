#!/bin/bash

# Author: Alysson Ajackson
# Date: Sun Dec 16 01:20:13 BRST 2012
# Version 1:    Create db, with fixed params
# Version 2:    Improved params list, allow to
#               pass just the "database name", then
#               user and password will be the default ones
#

#initialize vars

command=mysql
error=0

#processing 1st param

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]; then
    echo "Usage:
        $(basename "$0") \"new_db_name\" [\"db_password\" \"db_user\"]
        if password or user isn't set, default will be: \"root\" and \"\"
    "
    exit 0;
fi

if [ -n "$1" ]; then
    database="$1"
else
    echo "Invalid DB name."
    exit 1
fi

if [ -n "$2" ]; then
    password="$2"
else
    password=""
fi

if [ -n "$3" ]; then
    user="$3"
else
    user="root"
fi

####if [ -x "$command" ]; then
# FIXME: use command $(which)

if [ -n "$command" ]; then
    "$command" -u "$user" -p"$password" -e "CREATE DATABASE $database DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci";
    error=$?;
else
    error=1;
fi

if [ "$error" -ne 0 ]; then
    echo "Error found! Please try again.";
else
    echo "Database $database was created!";
fi

exit $error;
