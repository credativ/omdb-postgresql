# using PG version with archive format compatible with older releases
PGVERSION = 11
PGUSER = postgres

dump: omdb.dump

omdb.dump: www.omdb.org/data/all_movies.csv.bz2
	pg_virtualenv -i '--auth=trust --username=$(PGUSER)' -v $(PGVERSION) sh -c "export PGUSER=$(PGUSER) && ./import && pg_dump -Fc -f $@ omdb"

www.omdb.org/data/all_movies.csv.bz2:
	./download

clean:
	rm -rf omdb.dump www.omdb.org
