#!/bin/bash

# Enable OMDB CGI on CentOS via Apache

set -e

if ! test -f omdb.cgi; then
	echo "Could not find omdb.cgi!"
	echo "Make sure it's within PWD"
	exit 1
fi

# install and configure apache2
yum install httpd \
	perl-CGI \
	perl-DBD-Pg \
	perl-Template-Toolkit

# restart apache
service httpd restart

# install CGI script
rm -rf /var/www/cgi-bin/omdb /var/www/cgi-bin/templates
cp -r omdb.cgi /var/www/cgi-bin/omdb
cp -r templates /var/www/cgi-bin
chmod +x /var/www/cgi-bin/omdb

# create PostgreSQL user
su -c 'createuser apache' postgres || :

cat <<EOF
#######################################
The OMDB CGI script has been installed:

     http://localhost/cgi-bin/omdb
#######################################
EOF
