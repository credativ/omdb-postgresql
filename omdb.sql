\i 00-drop-tables.sql
\i 10-country_codes.sql
\i 11-iso639.sql
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

CREATE EXTENSION IF NOT EXISTS tsm_system_rows;
DO $$ BEGIN
  CREATE USER "www-data";
EXCEPTION WHEN duplicate_object THEN
END; $$ LANGUAGE plpgsql;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "www-data";
