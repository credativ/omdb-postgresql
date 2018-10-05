\set year random(1900, 2018)
\set month random(1, 12)
\set day random(1, 28)

SELECT * FROM (SELECT * FROM movies WHERE date < (:year||'-'||:month||'-'||:day)::date ORDER BY DATE DESC LIMIT 10) older UNION ALL SELECT * FROM movies WHERE date = (:year||'-'||:month||'-'||:day)::date UNION ALL SELECT * FROM (SELECT * FROM movies WHERE date > (:year||'-'||:month||'-'||:day)::date ORDER BY DATE LIMIT 10) newer;
