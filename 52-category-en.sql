/* Add English category name from category_names to category table for convenience */

UPDATE categories c
  SET name = n.name
  FROM category_names n
  WHERE c.id = n.category_id AND n.language = 'en';

-- Some categories do not have English names, fall back to German
UPDATE categories c
  SET name = n.name
  FROM category_names n
  WHERE c.id = n.category_id AND n.language = 'de' AND c.name IS NULL;
