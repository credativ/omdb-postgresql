BEGIN;
CREATE TEMP TABLE dirty_categories (category_id bigint PRIMARY KEY);
-- This surely doesn't catch 'em all, but it'll remove quite a few
INSERT INTO dirty_categories
        SELECT id FROM categories WHERE name LIKE 'Erotic%' OR name = 'Sex';
ANALYZE dirty_categories;

CREATE INDEX t1 ON casts(movie_id);
CREATE INDEX t2 ON movie_categories(movie_id);
CREATE INDEX t3 ON movie_keywords(movie_id);
CREATE INDEX t4 ON movies(parent_id);
CREATE INDEX t5 ON movies(series_id);

DELETE FROM movies m USING movie_keywords k JOIN dirty_categories d ON k.category_id = d.category_id WHERE m.id = k.movie_id;
DELETE FROM movies m USING movie_categories k JOIN dirty_categories d ON k.category_id = d.category_id WHERE m.id = k.movie_id;

DROP INDEX t1;
DROP INDEX t2;
DROP INDEX t3;
DROP INDEX t4;
DROP INDEX t5;
COMMIT;
