--\set country DE

SELECT m.* FROM movies m JOIN movie_countries c ON (m.id = c.movie_id) WHERE c.country = 'DE' ORDER BY m.date;
