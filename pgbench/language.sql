--\set language de

SELECT m.* FROM movies m JOIN movie_languages l ON (m.id = l.movie_id) WHERE l.language = 'de' ORDER BY m.date;
