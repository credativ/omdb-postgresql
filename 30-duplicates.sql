BEGIN;

WITH t as (
  select ctid, row_number() over (partition by movie_id, name, language, official_translation), * from movie_aliases_iso
  )
DELETE from movie_aliases_iso where ctid in ( select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by person_id, name), * from people_aliases
  )
DELETE from people_aliases where ctid in ( select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_de
  )
DELETE from movie_abstracts_de where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_en
  )
DELETE from movie_abstracts_en where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_fr
  )
DELETE from movie_abstracts_fr where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_es
  )
DELETE from movie_abstracts_es where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id, country), * from movie_countries
  )
DELETE from movie_countries where ctid in (select ctid FROM t WHERE row_number > 1);

DELETE FROM movie_languages WHERE language IS NULL;

WITH t as (
  select ctid, row_number() over (partition by movie_id, language), * from movie_languages
  )
DELETE from movie_languages where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id, language), * from movie_links
  )
DELETE from movie_links where ctid in (select ctid FROM t WHERE row_number > 1);

DELETE FROM movie_references WHERE type IS NULL;

WITH t as (
  select ctid, row_number() over (partition by movie_id, referenced_id, type), * from movie_references
  )
DELETE from movie_references where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by movie_id, person_id, job_id, role, "position"), * from casts
  )
DELETE from casts where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by category_id, language), * from category_names
  )
DELETE from category_names where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by job_id, language), * from job_names
  )
DELETE from job_names where ctid in (select ctid FROM t WHERE row_number > 1);

WITH t as (
  select ctid, row_number() over (partition by id), * from jobs
  )
DELETE from jobs where ctid in (select ctid FROM t WHERE row_number > 1);

COMMIT;
