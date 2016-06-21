BEGIN;

CREATE TABLE all_movies (id bigint, name text, parent_id bigint, date date);
CREATE TABLE all_series (id bigint, name text, parent_id bigint, date date);
CREATE TABLE all_seasons (id bigint, name text, parent_id bigint, date date);
CREATE TABLE all_episodes (id bigint, name text, parent_id bigint, date date, series_id bigint);
CREATE TABLE all_people (id bigint, name text, birthday date, deathday date, gender int);
CREATE TABLE all_people_aliases (person_id bigint, name text);
CREATE TABLE people_links (source text, key text, people_id bigint, language_iso_639_1 varchar(2));
CREATE TABLE all_casts (movie_id bigint, person_id bigint, job_id bigint, role text, position int);
CREATE TABLE job_names (job_id bigint, name text, language_iso_639_1 varchar(2));
CREATE TABLE all_characters (id bigint, name text);
CREATE TABLE movie_categories (movie_id bigint, category_id bigint);
CREATE TABLE movie_keywords (movie_id bigint, category_id bigint);
CREATE TABLE category_names (category_id bigint, name text, language_iso_639_1 varchar(2));
CREATE TABLE trailers (trailer_id bigint, key text, movie_id bigint, language_iso_639_1 varchar(2));
CREATE TABLE movie_links (source text, key text, movie_id bigint, language_iso_639_1 varchar(2));
CREATE TABLE image_ids (image_id bigint, object_id bigint, object_type text, image_version int);
CREATE TABLE image_licenses (image_id bigint, source text, license_id bigint, author text);
CREATE TABLE all_movie_aliases_iso (movie_id bigint, name text, language_iso_639_1 varchar(2), official_translation int);
CREATE TABLE all_votes (movie_id bigint, vote_average numeric, votes_count bigint);
CREATE TABLE movie_languages (movie_id bigint, language_iso_639_1 varchar(2));
CREATE TABLE movie_countries (movie_id bigint, country_code varchar(2));
CREATE TABLE movie_details (movie_id bigint, runtime int, budget numeric, revenue numeric, homepage text);
CREATE TABLE movie_references (movie_id bigint, referenced_id bigint, type text);
CREATE TABLE movie_abstracts_de (movie_id bigint, abstract text);
CREATE TABLE movie_abstracts_en (movie_id bigint, abstract text);

COMMENT ON TABLE trailers is 'Youtube Trailer';

COMMIT;
