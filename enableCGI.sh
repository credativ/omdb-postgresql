#!/bin/bash

#Simple script to enable CGI on Debian via APACHE


apt-get install apache2
a2enmod cgi

test -f omdb.cgi
if [ $? -ne 0 ]; then 
	echo "Could not find omdb.cgi!"
	echo "Make sure it's within PWD"
	exit 1;
fi

ln -s `pwd`/omdb.cgi /usr/lib/cgi-bin/omdb

cat /etc/apache2/conf-available/serve-cgi-bin.conf | sed s/SymLinksIfOwnerMatch/FollowSymLinks/g > /etc/apache2/conf-available/serve-cgi-bin.conf.new
mv /etc/apache2/conf-available/serve-cgi-bin.conf.new /etc/apache2/conf-available/serve-cgi-bin.conf

/etc/init.d/apache2 restart
