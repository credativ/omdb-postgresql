BEGIN;

DROP TABLE IF EXISTS title;
CREATE TABLE title (id bigint, name text, parent_id bigint, date date, series_id bigint DEFAULT NULL, kind text);

INSERT INTO title (SELECT id, name, parent_id, date, NULL, 'movie' FROM all_movies);
INSERT INTO title (SELECT id, name, parent_id, date, NULL, 'series' FROM all_series);
INSERT INTO title (SELECT id, name, parent_id, date, NULL, 'season' FROM all_seasons);
INSERT INTO title (SELECT id, name, parent_id, date, series_id, 'episode' FROM all_episodes);

DROP TABLE all_movies;
DROP TABLE all_series;
DROP TABLE all_seasons;
DROP TABLE all_episodes;

ALTER TABLE all_characters ADD PRIMARY KEY (id);
WITH t as (
  select ctid, row_number() over (partition by movie_id, name, language_iso_639_1, official_translation), * from all_movie_aliases_iso
  )
DELETE from all_movie_aliases_iso where ctid in ( select ctid FROM t WHERE row_number > 1);
ALTER TABLE all_movie_aliases_iso ADD PRIMARY KEY (movie_id, name, language_iso_639_1, official_translation);
ALTER TABLE all_people ADD PRIMARY KEY (id);
WITH t as (
  select ctid, row_number() over (partition by person_id, name), * from all_people_aliases
  )
DELETE from all_people_aliases where ctid in ( select ctid FROM t WHERE row_number > 1);
ALTER TABLE all_people_aliases ADD PRIMARY KEY (person_id, name);
ALTER TABLE all_votes ADD PRIMARY KEY (movie_id);
ALTER TABLE category_names ADD PRIMARY KEY (category_id, language_iso_639_1);
ALTER TABLE image_ids ADD PRIMARY KEY (image_id);
ALTER TABLE image_licenses ADD PRIMARY KEY (image_id);
ALTER TABLE job_names ADD PRIMARY KEY (job_id, language_iso_639_1);
WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_de
  )
DELETE from movie_abstracts_de where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE movie_abstracts_de ADD PRIMARY KEY (movie_id);
WITH t as (
  select ctid, row_number() over (partition by movie_id), * from movie_abstracts_en
  )
DELETE from movie_abstracts_en where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE movie_abstracts_en ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_categories ADD PRIMARY KEY (movie_id, category_id);
ALTER TABLE movie_countries ADD PRIMARY KEY (movie_id, country_code);
ALTER TABLE movie_details ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_keywords  ADD PRIMARY KEY (movie_id, category_id);
DELETE FROM movie_languages WHERE language_iso_639_1 IS NULL;
WITH t as (
  select ctid, row_number() over (partition by movie_id, language_iso_639_1), * from movie_languages
  )
DELETE from movie_languages where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE movie_languages ADD PRIMARY KEY (movie_id, language_iso_639_1); -- null in language
WITH t as (
  select ctid, row_number() over (partition by movie_id, language_iso_639_1), * from movie_links
  )
DELETE from movie_links where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE movie_links ADD PRIMARY KEY (movie_id, language_iso_639_1, key);
DELETE FROM movie_references WHERE type IS NULL;
WITH t as (
  select ctid, row_number() over (partition by movie_id, referenced_id, type), * from movie_references
  )
DELETE from movie_references where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE movie_references ADD PRIMARY KEY (movie_id, referenced_id, type);
ALTER TABLE people_links ADD PRIMARY KEY (people_id, language_iso_639_1, key);
ALTER TABLE title ADD PRIMARY KEY (id);
ALTER TABLE trailers ADD PRIMARY KEY (movie_id, trailer_id);

-- all_casts beinhaltet Dubletten
WITH t as (
  select ctid, row_number() over (partition by movie_id, person_id, job_id, role, "position"), * from all_casts
  )
DELETE from all_casts where ctid in (select ctid FROM t WHERE row_number > 1);
ALTER TABLE all_casts ADD PRIMARY KEY (movie_id, person_id, job_id, role, position);

COMMIT;
