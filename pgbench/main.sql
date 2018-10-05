SELECT * FROM movies TABLESAMPLE system_rows(1000) WHERE kind = 'movie' ORDER BY random() LIMIT 10;
SELECT * FROM movies TABLESAMPLE system_rows(1000) WHERE kind = 'series' ORDER BY random() LIMIT 10;
SELECT * FROM people TABLESAMPLE system_rows(1000) ORDER BY random() LIMIT 10;
SELECT * FROM casts TABLESAMPLE system_rows(1000) WHERE role IS NOT NULL AND role NOT IN ('', '-') ORDER BY random() LIMIT 10;
SELECT * FROM categories TABLESAMPLE system_rows(1000) ORDER BY random() LIMIT 10;
