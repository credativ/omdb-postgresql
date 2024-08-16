FROM postgres:14.5
# requirements to run ./download
RUN apt-get update
RUN apt-get install -y wget && apt-get install -y bzip2

COPY . omdb-postgresql
COPY docker-import /docker-entrypoint-initdb.d/docker-import.sh

WORKDIR omdb-postgresql

RUN "./download"