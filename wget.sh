#!/bin/sh

rm -rf localhost
trap "rm -rf localhost" 0 2 3 15

wget --no-check-certificate --auth-no-challenge -r -np -nv https://admin:admin@localhost/cgi-bin/omdb/
