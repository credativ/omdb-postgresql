--\set query '%Hitchcock%'

SELECT * FROM movies m WHERE name ILIKE '%Hitchcock%' ORDER BY m.date, m.name;
SELECT * FROM people p WHERE name ILIKE '%Hitchcock%' ORDER BY p.name;
SELECT *, p.name AS person_name, m.name AS movie_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN movies m ON (c.movie_id = m.id) WHERE c.role ILIKE '%Hitchcock%' ORDER BY m.date;
SELECT * FROM categories c WHERE name ILIKE '%Hitchcock%' ORDER BY c.name;
