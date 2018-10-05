pgbench scripts for omdb
------------------------

This directory contains the same queries as `omdb.cgi`, but as scripts for
`pgbench`.

Example with a 10 second benchmark:

```
$ ./pgbench.sh -T 10
transaction type: multiple scripts
scaling factor: 1
query mode: simple
number of clients: 1
number of threads: 1
duration: 10 s
number of transactions actually processed: 143
latency average = 70.152 ms
tps = 14.254777 (including connections establishing)
tps = 14.259406 (excluding connections establishing)
SQL script 1: movie.sql
 - weight: 10 (targets 25.0% of total)
 - 38 transactions (26.6% of total, tps = 3.787983)
 - latency average = 83.398 ms
 - latency stddev = 27.607 ms
SQL script 2: person.sql
 - weight: 10 (targets 25.0% of total)
 - 38 transactions (26.6% of total, tps = 3.787983)
 - latency average = 72.102 ms
 - latency stddev = 36.193 ms
SQL script 3: character.sql
 - weight: 1 (targets 2.5% of total)
 - 5 transactions (3.5% of total, tps = 0.498419)
 - latency average = 27.330 ms
 - latency stddev = 1.054 ms
SQL script 4: category.sql
 - weight: 5 (targets 12.5% of total)
 - 17 transactions (11.9% of total, tps = 1.694624)
 - latency average = 31.447 ms
 - latency stddev = 4.604 ms
SQL script 5: date.sql
 - weight: 5 (targets 12.5% of total)
 - 18 transactions (12.6% of total, tps = 1.794308)
 - latency average = 116.188 ms
 - latency stddev = 2.671 ms
SQL script 6: job.sql
 - weight: 5 (targets 12.5% of total)
 - 17 transactions (11.9% of total, tps = 1.694624)
 - latency average = 26.910 ms
 - latency stddev = 3.012 ms
SQL script 7: country.sql
 - weight: 1 (targets 2.5% of total)
 - 4 transactions (2.8% of total, tps = 0.398735)
 - latency average = 33.480 ms
 - latency stddev = 1.213 ms
SQL script 8: language.sql
 - weight: 1 (targets 2.5% of total)
 - 1 transactions (0.7% of total, tps = 0.099684)
 - latency average = 36.970 ms
 - latency stddev = 0.000 ms
SQL script 9: main.sql
 - weight: 1 (targets 2.5% of total)
 - 3 transactions (2.1% of total, tps = 0.299051)
 - latency average = 3.878 ms
 - latency stddev = 0.646 ms
SQL script 10: search.sql
 - weight: 1 (targets 2.5% of total)
 - 2 transactions (1.4% of total, tps = 0.199368)
 - latency average = 358.410 ms
 - latency stddev = 0.493 ms
```
