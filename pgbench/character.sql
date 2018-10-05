--\set character Alfred Hitchcock

SELECT *, p.name AS person_name, m.name AS movie_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN movies m ON (c.movie_id = m.id) WHERE c.role = 'Alfred Hitchcock' ORDER BY m.date;
