BEGIN;

--ALTER TABLE characters         ADD PRIMARY KEY (id);
ALTER TABLE movie_aliases_iso  ADD PRIMARY KEY (movie_id, name, language, official_translation);
ALTER TABLE people             ADD PRIMARY KEY (id);
ALTER TABLE people_aliases     ADD PRIMARY KEY (person_id, name);
ALTER TABLE category_names     ADD PRIMARY KEY (category_id, language);
ALTER TABLE categories         ADD PRIMARY KEY (id);
ALTER TABLE image_ids          ADD PRIMARY KEY (id);
ALTER TABLE image_licenses     ADD PRIMARY KEY (image_id);
ALTER TABLE job_names          ADD PRIMARY KEY (job_id, language);
ALTER TABLE jobs               ADD PRIMARY KEY (id);
ALTER TABLE movie_abstracts_de ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_abstracts_en ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_abstracts_fr ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_abstracts_es ADD PRIMARY KEY (movie_id);
ALTER TABLE movie_categories   ADD PRIMARY KEY (movie_id, category_id);
ALTER TABLE movie_countries    ADD PRIMARY KEY (movie_id, country);
ALTER TABLE movie_keywords     ADD PRIMARY KEY (movie_id, category_id);
ALTER TABLE movie_languages    ADD PRIMARY KEY (movie_id, language);
ALTER TABLE movie_links        ADD PRIMARY KEY (movie_id, language, key);
ALTER TABLE movie_references   ADD PRIMARY KEY (movie_id, referenced_id, type);
ALTER TABLE people_links       ADD PRIMARY KEY (person_id, language, key);
ALTER TABLE movies             ADD PRIMARY KEY (id);
ALTER TABLE trailers           ADD PRIMARY KEY (movie_id, trailer_id);
ALTER TABLE casts              ADD PRIMARY KEY (movie_id, person_id, job_id, role, position);

COMMIT;
