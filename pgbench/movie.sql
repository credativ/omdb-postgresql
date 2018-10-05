\set movie_id random(1, 114882)

SELECT * FROM movies WHERE id = :movie_id;
SELECT * FROM movie_aliases_iso WHERE movie_id = :movie_id ORDER BY language, official_translation DESC, name;
--SELECT * FROM movies WHERE id = :series_id;
--SELECT * FROM movies WHERE id = :parent_id;
SELECT * FROM movies WHERE parent_id = :movie_id ORDER BY date;
SELECT * FROM movies WHERE series_id = :movie_id ORDER BY date;
SELECT language FROM movie_languages WHERE movie_id = :movie_id;
SELECT country FROM movie_countries WHERE movie_id = :movie_id;
SELECT * FROM movie_abstracts_de WHERE movie_id = :movie_id;
SELECT * FROM movie_abstracts_en WHERE movie_id = :movie_id;
SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = :movie_id AND i.object_type = 'Movie' AND source <> '';
SELECT * FROM trailers WHERE movie_id = :movie_id ORDER BY language, trailer_id;
SELECT *, p.name AS person_name, j.name AS job_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN jobs j ON (c.job_id = j.id) WHERE c.movie_id = :movie_id ORDER BY c.position, j.name, p.name;
SELECT * FROM movie_references r JOIN movies m ON (r.referenced_id = m.id) WHERE movie_id = :movie_id ORDER BY type, date;
SELECT * FROM movie_references r JOIN movies m ON (r.movie_id = m.id) WHERE referenced_id = :movie_id ORDER BY type, date;
SELECT * FROM movie_links WHERE movie_id = :movie_id ORDER BY source, key, language;
SELECT c.* FROM categories c JOIN movie_categories m ON (c.id = m.category_id) WHERE m.movie_id = :movie_id ORDER BY c.name;
SELECT c.* FROM categories c JOIN movie_keywords m ON (c.id = m.category_id) WHERE m.movie_id = :movie_id ORDER BY c.name;
--SELECT * FROM movies WHERE id <> :movie_id ORDER BY name <-> :movie_name LIMIT 10;
