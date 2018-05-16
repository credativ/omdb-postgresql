#!/bin/sh

# simple OMDB benchmark

# if localhost needs username/password, put it in ~/.netrc:
# machine localhost login admin password admin

# clean up downloaded files
rm -rf localhost
trap "rm -rf localhost" 0 2 3 15

wget --no-check-certificate --auth-no-challenge -r -np -nv https://localhost/cgi-bin/omdb/
