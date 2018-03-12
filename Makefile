dump: omdb.dump

omdb.dump: www.omdb.org/data/all_movies.csv.bz2
	./import
	pg_dump -Fc -f $@ omdb

www.omdb.org/data/all_movies.csv.bz2:
	./download

clean:
	rm -rf omdb.dump www.omdb.org
