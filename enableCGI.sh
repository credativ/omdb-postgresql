#!/bin/bash

# Enable OMDB CGI on Debian via Apache

set -e

if ! test -f omdb.cgi; then
	echo "Could not find omdb.cgi!"
	echo "Make sure it's within PWD"
	exit 1
fi

# install and configure apache2
apt-get install apache2 \
	libcgi-pm-perl \
	libdbd-pg-perl \
	libtemplate-perl
a2enmod cgi
sed -i -e 's/SymLinksIfOwnerMatch/FollowSymLinks/g' /etc/apache2/conf-available/serve-cgi-bin.conf

# restart apache (reloading is not enough on stretch)
service apache2 restart

# install CGI script
rm -f /usr/lib/cgi-bin/omdb
ln -s $PWD/omdb.cgi /usr/lib/cgi-bin/omdb
chmod +x omdb.cgi

# create PostgreSQL user
su -c 'createuser www-data' postgres || :

cat <<EOF
#######################################
The OMDB CGI script has been installed:

     http://localhost/cgi-bin/omdb
#######################################
EOF
