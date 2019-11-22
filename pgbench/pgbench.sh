#!/bin/sh

# CentOS compatibility
for dir in /usr/pgsql-*/bin; do
  test -d "$dir" && PATH="$dir:$PATH"
done

# suggested options:
# ./pgbench.sh --time 3600 --client 4 --progress 5

pgbench -n \
  -f movie.sql@10 \
  -f person.sql@10 \
  -f character.sql@1 \
  -f category.sql@5 \
  -f date.sql@5 \
  -f job.sql@5 \
  -f country.sql@1 \
  -f language.sql@1 \
  -f main.sql@1 \
  -f search.sql@1 \
  "$@" omdb
