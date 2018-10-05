\set job_id random(1, 826)

SELECT * FROM jobs WHERE id = :job_id;
SELECT p.id, p.name, COUNT(*) FROM people p JOIN casts c ON (p.id = c.person_id) WHERE c.job_id = :job_id GROUP BY p.id, p.name ORDER BY p.name LIMIT 10000;
