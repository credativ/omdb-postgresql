BEGIN;

CREATE TABLE access_log (
  time timestamptz NOT NULL DEFAULT now(),
  client_ip inet,
  page text NOT NULL,
  path text NOT NULL,
  runtime double precision
);

COMMIT;
