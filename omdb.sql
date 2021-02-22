\i 00-drop-tables.sql
\i 12-kind.sql
\i 13-schema.sql
\i 20-import.sql
\i 30-duplicates.sql
VACUUM;
\i 31-primary-keys.sql
\i 40-clean-orphans.sql
VACUUM;
\i 41-foreign-keys.sql
ANALYZE;
\i 50-views.sql
\i 52-category-en.sql
\i 55-purge_dirty.sql
\i 60-log.sql

GRANT SELECT ON ALL TABLES IN SCHEMA public TO public;
GRANT INSERT ON access_log TO public;
