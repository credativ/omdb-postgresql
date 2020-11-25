BEGIN;

CREATE TEMP TABLE IF NOT EXISTS all_movies      (id bigint, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_series      (id bigint, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_seasons     (id bigint, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS all_episodes    (id bigint, name text, parent_id bigint, date date, series_id bigint);
CREATE TEMP TABLE IF NOT EXISTS all_movieseries (id bigint, name text, parent_id bigint, date date);
CREATE TEMP TABLE IF NOT EXISTS movie_details (movie_id bigint, runtime int, budget numeric, revenue numeric, homepage text);
CREATE TEMP TABLE IF NOT EXISTS votes (movie_id bigint, vote_average numeric, votes_count bigint);

\copy all_movies            FROM PROGRAM 'bzcat www.omdb.org/data/all_movies.csv.bz2'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_series            FROM PROGRAM 'bzcat www.omdb.org/data/all_series.csv.bz2'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_seasons           FROM PROGRAM 'bzcat www.omdb.org/data/all_seasons.csv.bz2'           WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_episodes          FROM PROGRAM 'bzcat www.omdb.org/data/all_episodes.csv.bz2'          WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy all_movieseries       FROM PROGRAM 'bzcat www.omdb.org/data/all_movieseries.csv.bz2'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_details         FROM PROGRAM 'bzcat www.omdb.org/data/movie_details.csv.bz2'         WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy votes                 FROM PROGRAM 'bzcat www.omdb.org/data/all_votes.csv.bz2'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')

WITH import_movies AS (
	SELECT id, name, parent_id, date, NULL::bigint AS series_id, 'movie'::kind AS kind FROM all_movies
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'series' FROM all_series
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'season' FROM all_seasons
	UNION ALL
	SELECT id, name, parent_id, date, series_id, 'episode' FROM all_episodes
	UNION ALL
	SELECT id, name, parent_id, date, NULL, 'movieseries' FROM all_movieseries
)
INSERT INTO movies
(SELECT id, name, parent_id, date, series_id, kind, -- from import_movies
	runtime, budget, revenue, homepage, -- from movie_details
	vote_average, votes_count -- from votes
FROM import_movies m
	LEFT JOIN movie_details d ON m.id = d.movie_id
	LEFT JOIN votes v ON m.id = v.movie_id);

\copy people                FROM PROGRAM 'bzcat www.omdb.org/data/all_people.csv.bz2'            WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy people_aliases        FROM PROGRAM 'bzcat www.omdb.org/data/all_people_aliases.csv.bz2'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
-- people_links contains duplicates (2016-11-07)
\copy people_links          FROM PROGRAM 'bzcat www.omdb.org/data/people_links.csv.bz2 | tail -n +2 | sort -u' WITH (FORMAT CSV, HEADER FALSE, NULL '\N', ESCAPE '\')
\copy casts                 FROM PROGRAM 'bzcat www.omdb.org/data/all_casts.csv.bz2'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy job_names             FROM PROGRAM 'bzcat www.omdb.org/data/job_names.csv.bz2'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
INSERT INTO jobs SELECT job_id, name FROM job_names WHERE language = 'en';
--\copy characters          FROM PROGRAM 'bzcat www.omdb.org/data/all_characters.csv.bz2'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_categories      FROM PROGRAM 'bzcat www.omdb.org/data/movie_categories.csv.bz2'      WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_keywords        FROM PROGRAM 'bzcat www.omdb.org/data/movie_keywords.csv.bz2'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy category_names        FROM PROGRAM 'bzcat www.omdb.org/data/category_names.csv.bz2'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy categories (id, parent_id, root_id) FROM PROGRAM 'bzcat www.omdb.org/data/all_categories.csv.bz2' WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy trailers              FROM PROGRAM 'bzcat www.omdb.org/data/trailers.csv.bz2'              WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_links           FROM PROGRAM 'bzcat www.omdb.org/data/movie_links.csv.bz2'           WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy image_ids             FROM PROGRAM 'bzcat www.omdb.org/data/image_ids.csv.bz2'             WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy image_licenses        FROM PROGRAM 'bzcat www.omdb.org/data/image_licenses.csv.bz2'        WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_aliases_iso     FROM PROGRAM 'bzcat www.omdb.org/data/all_movie_aliases_iso.csv.bz2' WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_languages       FROM PROGRAM 'bzcat www.omdb.org/data/movie_languages.csv.bz2'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_countries       FROM PROGRAM 'bzcat www.omdb.org/data/movie_countries.csv.bz2'       WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_references      FROM PROGRAM 'bzcat www.omdb.org/data/movie_references.csv.bz2'      WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_de    FROM PROGRAM 'bzcat www.omdb.org/data/movie_abstracts_de.csv.bz2'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_en    FROM PROGRAM 'bzcat www.omdb.org/data/movie_abstracts_en.csv.bz2'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_fr    FROM PROGRAM 'bzcat www.omdb.org/data/movie_abstracts_fr.csv.bz2'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')
\copy movie_abstracts_es    FROM PROGRAM 'bzcat www.omdb.org/data/movie_abstracts_es.csv.bz2'    WITH (FORMAT CSV, HEADER TRUE, NULL '\N', ESCAPE '\')

COMMIT;
