#!/bin/bash

# Enable OMDB CGI on Debian via Apache

set -e

if ! test -f omdb.cgi; then
	echo "Could not find omdb.cgi!"
	echo "Make sure it's within PWD"
	exit 1
fi

apt-get install apache2 \
	libcgi-pm-perl \
	libdbd-pg-perl \
	libtemplate-perl 
a2enmod cgi

rm -f /usr/lib/cgi-bin/omdb
ln -s $PWD/omdb.cgi /usr/lib/cgi-bin/omdb

sed -i -e 's/SymLinksIfOwnerMatch/FollowSymLinks/g' /etc/apache2/conf-available/serve-cgi-bin.conf

service apache2 reload

echo "http://localhost/cgi-bin/omdb"
