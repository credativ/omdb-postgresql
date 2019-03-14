CREATE TYPE kind AS ENUM (
'movie',
'series',
'season',
'episode',
'movieseries'
);
ALTER TYPE kind OWNER TO postgres;
