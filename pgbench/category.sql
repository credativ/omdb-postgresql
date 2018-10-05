\set category_id random(1, 19243)

SELECT * FROM categories WHERE id = :category_id;
SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = :category_id AND i.object_type = 'Category' AND source <> '';
SELECT m.* FROM movies m JOIN movie_categories c ON (m.id = c.movie_id) WHERE c.category_id = :category_id ORDER BY m.date;
SELECT m.* FROM movies m JOIN movie_keywords k ON (m.id = k.movie_id) WHERE k.category_id = :category_id ORDER BY m.date;
