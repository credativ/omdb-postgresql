# use oldest pg_dump available (>= 10) so the dump format is most compatible
PG_DUMP = $(firstword $(shell ls -v /usr/lib/postgresql/[123]*/bin/pg_dump /usr/pgsql-[123]*/bin/pg_dump 2> /dev/null))
PGVERSION0 = $(patsubst /usr/lib/postgresql/%/bin/pg_dump,%,$(PG_DUMP))
PGVERSION = $(patsubst /usr/pgsql-%/bin/pg_dump,%,$(PGVERSION0))
PGUSER = postgres

dump: omdb.dump

omdb.dump: www.omdb.org/data/all_movies.csv
	pg_virtualenv -i '--auth=trust --username=$(PGUSER)' -v $(PGVERSION) \
		sh -c "export PGUSER=$(PGUSER) && \
			./import && \
			$(PG_DUMP) -Fc -f $@ omdb"

www.omdb.org/data/all_movies.csv.bz2:
	./download

clean:
	rm -f omdb.dump www.omdb.org/data/*.bz2
