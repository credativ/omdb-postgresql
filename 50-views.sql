CREATE VIEW casts_view AS
  SELECT
    c.movie_id,
    m.name AS movie_name,
    parent_id,
    date,
    series_id,
    kind,
    runtime,
    budget,
    revenue,
    homepage,
    vote_average,
    votes_count,
    c.person_id,
    p.name AS person_name,
    birthday,
    deathday,
    gender,
    c.job_id,
    j.name AS job_name,
    c.role,
    c.position
  FROM casts c
    JOIN movies m ON c.movie_id = m.id
    JOIN people p ON c.person_id = p.id
    JOIN jobs j ON c.job_id = j.id;
