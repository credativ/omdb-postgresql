About omdb
----------

https://www.omdb.org/content/About

omdb (open media database) is a free database for film media. There is no set
editorial staff, but rather a large number of movie addicts and lovers who
volunteer their time to provide material and develop the site. Anybody can add
or change existing information on omdb once they have done the quick and simple
task of signing up for their user login name. Films will thus be represented
with equal opportunities hence Blockbusters, Soap Operas, and a college thesis
film will each have their own place on omdb.

omdb is a non-commercial project. All the contents of the site are published
under the Creative Commons License. The database therefore represents a
contribution to free knowledge on the Internet. The information does not belong
to a company or person but rather to the general public. omdb consciously stays
away from commercial related information with an objective to provide a
self-contained film database.

Copyright: Alle Textinformationen auf omdb.org unterliegen der Creative
Commons-Lizenz (Namensnennung 2.0 Deutschland).

https://www.omdb.org/content/Copyright
https://creativecommons.org/licenses/by/2.0/de/

About omdb-postgresql
---------------------

This database contains CSV data downloaded from https://www.omdb.org/content/Help:DataDownload,
imported into a normalized PostgreSQL database schema. The data is basically
unmodified, except for the removal of entries that would violate foreign key
constraints. The database import script also removes some adult movies.

The database schema is intentionally not optimized (no indexes besides primary
keys) in order to serve as a playground for database optimization.

This CGI script is developed by credativ, independently from omdb, and licensed
under the GNU GPL, version 2 or later.

List of other sample databases for PostgreSQL: https://wiki.postgresql.org/wiki/Sample_Databases

Building the omdb Database
--------------------------

Download the files from omdb.org:
```
./download
```

Import into the omdb PostgreSQL database:
```
./import
```

Create `omdb.dump` database export file:
```
pg_dump -Fc -f omdb.dump omdb
```
