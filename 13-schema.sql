BEGIN;

CREATE TABLE movies (
	id bigint, name text, parent_id bigint, date date, series_id bigint, kind kind, -- from all_*
	runtime int, budget numeric, revenue numeric, homepage text, -- from movie_details
	vote_average numeric, votes_count bigint -- from votes
);
CREATE TABLE people (id bigint, name text, birthday date, deathday date, gender int);
CREATE TABLE people_aliases (person_id bigint, name text);
CREATE TABLE people_links (source text, key text, person_id bigint, language text);
CREATE TABLE casts (movie_id bigint, person_id bigint, job_id bigint, role text, position int);
CREATE TABLE job_names (job_id bigint, name text, language text);
CREATE TABLE jobs (id bigint, name text);
COMMENT ON TABLE jobs IS 'English-only version of job_names';
--CREATE TABLE characters (id bigint, name text);
CREATE TABLE movie_categories (movie_id bigint, category_id bigint);
CREATE TABLE movie_keywords (movie_id bigint, category_id bigint);
CREATE TABLE categories (id bigint, parent_id bigint, root_id bigint, name text);
CREATE TABLE category_names (category_id bigint, name text, language text);
CREATE TABLE trailers (trailer_id bigint, key text, movie_id bigint, language text, source text);
COMMENT ON TABLE trailers is 'Youtube/Vimeo Trailer';
CREATE TABLE movie_links (source text, key text, movie_id bigint, language text);
CREATE TABLE image_ids (id bigint, object_id bigint, object_type text, image_version int);
CREATE TABLE image_licenses (image_id bigint, source text, license_id bigint, author text);
CREATE TABLE movie_aliases_iso (movie_id bigint, name text, language text, official_translation int);
CREATE TABLE movie_languages (movie_id bigint, language text);
CREATE TABLE movie_countries (movie_id bigint, country text);
CREATE TABLE movie_references (movie_id bigint, referenced_id bigint, type text);
CREATE TABLE movie_abstracts_de (movie_id bigint, abstract text);
CREATE TABLE movie_abstracts_en (movie_id bigint, abstract text);
CREATE TABLE movie_abstracts_fr (movie_id bigint, abstract text);
CREATE TABLE movie_abstracts_es (movie_id bigint, abstract text);

COMMIT;
