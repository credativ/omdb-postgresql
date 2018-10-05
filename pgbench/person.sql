\set person_id random(1, 249270)

SELECT * FROM people WHERE id = :person_id;
SELECT name FROM people_aliases WHERE person_id = :person_id;
SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = :person_id AND i.object_type = 'Person' AND source <> '';
SELECT *, m.name AS movie_name, j.name AS job_name FROM movies m JOIN casts c ON (m.id = c.movie_id) JOIN jobs j ON (c.job_id = j.id) WHERE c.person_id = :person_id ORDER BY m.date, j.name;
SELECT * FROM people_links WHERE person_id = :person_id ORDER BY source, key, language;
SELECT p.id,p.name, count(DISTINCT c1.movie_id) Partnerships FROM casts c1 JOIN casts c2 ON c2.movie_id = c1.movie_id JOIN people p ON c2.person_id = p.id WHERE c1.person_id = :person_id AND c2.person_id != :person_id GROUP BY 1, 2 ORDER BY 3 DESC LIMIT 5;
