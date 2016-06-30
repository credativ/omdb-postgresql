BEGIN;
CREATE INDEX _REMOVEME on categories (name text_pattern_ops);
COMMIT;
ANALYZE categories;
BEGIN;
-- This surely doesn't catch 'em all, but it'll remove quite a few
DELETE FROM movies WHERE EXISTS (SELECT movie_id FROM movie_keywords m JOIN categories c on m.category_id=c.id  WHERE  c.name like 'Erotic%' AND m.movie_id=movies.id);
DELETE FROM movies WHERE EXISTS (SELECT movie_id FROM movie_categories m JOIN categories c on m.category_id=c.id WHERE c.name like 'Erotic%' and m.movie_id=movies.id );
DROP INDEX _REMOVEME;
COMMIT;
