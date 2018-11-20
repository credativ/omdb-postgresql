#!/usr/bin/perl

# Copyright (C) 2016-2018 credativ GmbH <info@credativ.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use DBD::Pg;
use Encode;
use Template;
use Time::HiRes qw(gettimeofday);

binmode STDOUT, ':encoding(UTF-8)';


my $directory = readlink ($0) || $0;
$directory =~ s!/[^/]+$!!;

my $time_start=gettimeofday;
my $dbh = DBI->connect("dbi:Pg:dbname=omdb client_encoding=UTF-8", '', '',
	{ AutoCommit => 0, RaiseError => 1, PrintError => 0 });

# create Template object
my $template = Template->new(
	INCLUDE_PATH => "$directory/templates",
	PRE_PROCESS => "header",
	POST_PROCESS => "footer",
	INTERPOLATE => 1, # expand "$var" in plain text
	POST_CHOMP => 1, # weed whitespace
);

# create CGI object
my $q = CGI->new;
my $path = $q->path_info();

print $q->header(
	-type => 'text/html',
	-charset => 'utf-8',
);
sub error ($)
{
	my $error = shift;
	$template->process('error', {
		title => "Error: $error",
		error => $error,
	}) || die $template->error();
	exit;
}

sub selectall_hashrows
{
	my $sth = $dbh->prepare(shift);
	$sth->execute(@_);
	my @rows;
	while (my $row = $sth->fetchrow_hashref()) {
		push @rows, $row;
	}
	return \@rows;
}

sub process
{
	my ($t, $vars) = @_;
	$vars->{script_name} = $ENV{SCRIPT_NAME};
	my $time_end=gettimeofday;
	my $runtime = $time_end - $time_start;
	$vars->{time} = sprintf ("%.2fms", $runtime * 1000);

	my $output;
	$template->process ($t, $vars, \$output)
		|| die $template->error();
	print $output;

	$dbh->do("INSERT INTO access_log (client_ip, page, path, runtime) VALUES (?, ?, ?, ?)", undef,
		$ENV{REMOTE_ADDR}, $t, decode('UTF-8', $path), $runtime);
	$dbh->commit;
}

if ($path =~ m!^/movie/(\d+)!) {
	my $movie_id = $1;
	my $movie = $dbh->selectrow_hashref("SELECT * FROM movies WHERE id = ?", undef, $movie_id)
		or error ("Movie ID $movie_id is unknown");

	process('movie', {
		title => "$movie->{name} ($movie->{kind})",
		movie => $movie,
		aliases =>
			selectall_hashrows("SELECT * FROM movie_aliases_iso WHERE movie_id = ? ORDER BY language, official_translation DESC, name", $movie_id),
		series => $movie->{series_id} &&
			$dbh->selectrow_hashref("SELECT * FROM movies WHERE id = ?", undef, $movie->{series_id}),
		parent => $movie->{parent_id} &&
			$dbh->selectrow_hashref("SELECT * FROM movies WHERE id = ?", undef, $movie->{parent_id}),
		child_movies =>
			selectall_hashrows("SELECT * FROM movies WHERE parent_id = ? ORDER BY date", $movie_id),
		episodes =>
			selectall_hashrows("SELECT * FROM movies WHERE series_id = ? ORDER BY date", $movie_id),
		languages =>
			$dbh->selectcol_arrayref("SELECT language FROM movie_languages WHERE movie_id = ?", undef, $movie_id),
		countries =>
			$dbh->selectcol_arrayref("SELECT country FROM movie_countries WHERE movie_id = ?", undef, $movie_id),
		abstract_de =>
			$dbh->selectrow_hashref("SELECT * FROM movie_abstracts_de WHERE movie_id = ?", undef, $movie_id),
		abstract_en =>
			$dbh->selectrow_hashref("SELECT * FROM movie_abstracts_en WHERE movie_id = ?", undef, $movie_id),
		abstract_fr =>
			$dbh->selectrow_hashref("SELECT * FROM movie_abstracts_fr WHERE movie_id = ?", undef, $movie_id),
		abstract_es =>
			$dbh->selectrow_hashref("SELECT * FROM movie_abstracts_es WHERE movie_id = ?", undef, $movie_id),
		images =>
			selectall_hashrows("SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = ? AND i.object_type = 'Movie' AND source <> ''", $movie_id),
		trailers =>
			selectall_hashrows("SELECT * FROM trailers WHERE movie_id = ? ORDER BY language, trailer_id", $movie_id),
		cast =>
			selectall_hashrows("SELECT *, p.name AS person_name, j.name AS job_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN jobs j ON (c.job_id = j.id) WHERE c.movie_id = ? ORDER BY c.position, j.name, p.name", $movie_id),
		references_to =>
			selectall_hashrows("SELECT * FROM movie_references r JOIN movies m ON (r.referenced_id = m.id) WHERE movie_id = ? ORDER BY type, date", $movie_id),
		references_from =>
			selectall_hashrows("SELECT * FROM movie_references r JOIN movies m ON (r.movie_id = m.id) WHERE referenced_id = ? ORDER BY type, date", $movie_id),
		links =>
			selectall_hashrows("SELECT * FROM movie_links WHERE movie_id = ? ORDER BY source, key, language", $movie_id),
		categories =>
			selectall_hashrows("SELECT c.* FROM categories c JOIN movie_categories m ON (c.id = m.category_id) WHERE m.movie_id = ? ORDER BY c.name", $movie_id),
		keywords =>
			selectall_hashrows("SELECT c.* FROM categories c JOIN movie_keywords m ON (c.id = m.category_id) WHERE m.movie_id = ? ORDER BY c.name", $movie_id),
		similar =>
			selectall_hashrows("SELECT * FROM movies WHERE id <> ? ORDER BY name <-> ? LIMIT 10", $movie_id, $movie->{name}),
	});

} elsif ($path =~ m!^/person/(\d+)!) {
	my $person_id = $1;
	my $person = $dbh->selectrow_hashref("SELECT * FROM people WHERE id = ?", undef, $person_id)
		or error ("Person ID $person_id is unknown");

	process('person', {
		title => "$person->{name}",
		person => $person,
		aliases =>
			$dbh->selectcol_arrayref("SELECT name FROM people_aliases WHERE person_id = ?", undef, $person_id),
		images =>
			selectall_hashrows("SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = ? AND i.object_type = 'Person' AND source <> ''", $person_id),
		movies =>
			selectall_hashrows("SELECT *, m.name AS movie_name, j.name AS job_name FROM movies m JOIN casts c ON (m.id = c.movie_id) JOIN jobs j ON (c.job_id = j.id) WHERE c.person_id = ? ORDER BY m.date, j.name", $person_id),
		links =>
			selectall_hashrows("SELECT * FROM people_links WHERE person_id = ? ORDER BY source, key, language", $person_id),
		partners =>
			selectall_hashrows("SELECT p.id,p.name, count(DISTINCT c1.movie_id) Partnerships FROM casts c1 JOIN casts c2 ON c2.movie_id = c1.movie_id JOIN people p ON c2.person_id = p.id WHERE c1.person_id = ? AND c2.person_id != ? GROUP BY 1, 2 ORDER BY 3 DESC LIMIT 5", $person_id, $person_id),
	});

} elsif ($path =~ m!^/character/(.+)!) { # plain text
	my $character = decode('UTF-8', $1);

	process('character', {
		title => "$character",
		character => $character,
		cast => selectall_hashrows("SELECT *, p.name AS person_name, m.name AS movie_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN movies m ON (c.movie_id = m.id) WHERE c.role = ? ORDER BY m.date", $character),
	});

} elsif ($path =~ m!^/category/all!) {
	process('category', {
		title => "Categories and Keywords",
		children => selectall_hashrows("SELECT * FROM categories WHERE parent_id IS NULL ORDER BY name"),
	});

} elsif ($path =~ m!^/category/(\d+)!) {
	my $category_id = $1;
	my $category = $dbh->selectrow_hashref("SELECT * FROM categories WHERE id = ?", undef, $category_id)
		or error ("Category ID $category_id is unknown");

	process('category', {
		title => "$category->{name}",
		category => $category,
		names => selectall_hashrows("SELECT language, name FROM category_names WHERE category_id = ? ORDER BY language", $category_id),
		parents => selectall_hashrows("WITH RECURSIVE cat AS (SELECT id, parent_id, name, 1 AS row FROM categories WHERE id = ? union ALL SELECT c2.id, c2.parent_id, c2.name, cat.row + 1 FROM categories c2 JOIN cat ON c2.id = cat.parent_id) SELECT id, name FROM cat ORDER BY row desc", $category_id),
		children => selectall_hashrows("SELECT * FROM categories WHERE parent_id = ? ORDER BY name", $category_id),
		images =>
			selectall_hashrows("SELECT l.* FROM image_licenses l JOIN image_ids i ON l.image_id = i.id WHERE i.object_id = ? AND i.object_type = 'Category' AND source <> ''", $category_id),
		movies_cat => selectall_hashrows("SELECT m.* FROM movies m JOIN movie_categories c ON (m.id = c.movie_id) WHERE c.category_id = ? ORDER BY m.date", $category_id),
		movies_keyw => selectall_hashrows("SELECT m.* FROM movies m JOIN movie_keywords k ON (m.id = k.movie_id) WHERE k.category_id = ? ORDER BY m.date", $category_id),
	});

} elsif ($path =~ m!^/country/(\w+)!) {
	my $country = $1;

	process('country', {
		title => "Movies from $country",
		movies => selectall_hashrows("SELECT m.* FROM movies m JOIN movie_countries c ON (m.id = c.movie_id) WHERE c.country = ? ORDER BY m.date", $country),
	});

} elsif ($path =~ m!^/date/(\w+-\w+-\w+)!) {
	my $date = $1;

	process('date', {
		title => "Movies made around $date",
		movies => selectall_hashrows('SELECT * FROM (SELECT * FROM movies WHERE date < $1 ORDER BY DATE DESC LIMIT 10) older UNION ALL SELECT * FROM movies WHERE date = $1 UNION ALL SELECT * FROM (SELECT * FROM movies WHERE date > $1 ORDER BY DATE LIMIT 10) newer', $date),
	});

} elsif ($path =~ m!^/language/(\w+)!) {
	my $language = $1;

	process('language', {
		title => "Movies in $language",
		movies => selectall_hashrows("SELECT m.* FROM movies m JOIN movie_languages l ON (m.id = l.movie_id) WHERE l.language = ? ORDER BY m.date", $language),
	});

} elsif ($path =~ m!^/job/(\d+)!) {
	my $job_id = $1;
	my $job = $dbh->selectrow_hashref("SELECT * FROM jobs WHERE id = ?", undef, $job_id)
		or error ("Job ID $job_id is unknown");

	process('job', {
		title => "$job->{name} (Job title)",
		people => selectall_hashrows("SELECT p.id, p.name, COUNT(*) FROM people p JOIN casts c ON (p.id = c.person_id) WHERE c.job_id = ? GROUP BY p.id, p.name ORDER BY p.name LIMIT 10000", $job_id),
	});

} elsif ($path =~ m!^/?$!) {
	process('main', {
		title => "omdb",
		movies => selectall_hashrows("SELECT * FROM movies TABLESAMPLE system_rows(1000) WHERE kind = 'movie' ORDER BY random() LIMIT 10"),
		series => selectall_hashrows("SELECT * FROM movies TABLESAMPLE system_rows(1000) WHERE kind = 'series' ORDER BY random() LIMIT 10"),
		people => selectall_hashrows("SELECT * FROM people TABLESAMPLE system_rows(1000) ORDER BY random() LIMIT 10"),
		characters => selectall_hashrows("SELECT * FROM casts TABLESAMPLE system_rows(1000) WHERE role IS NOT NULL AND role NOT IN ('', '-') ORDER BY random() LIMIT 10"),
		categories => selectall_hashrows("SELECT * FROM categories TABLESAMPLE system_rows(1000) ORDER BY random() LIMIT 10"),
	});

} elsif ($path =~ m!^/search!) {
	my $query = decode ('UTF-8', $q->param('q')) || 'Hitchcock'; # shows up in movies, people, and characters

	process('search', {
		title => "Search results: $query",
		movies => selectall_hashrows("SELECT * FROM movies m WHERE name ILIKE ? ORDER BY m.date, m.name", "%$query%"),
		people => selectall_hashrows("SELECT * FROM people p WHERE name ILIKE ? ORDER BY p.name", "%$query%"),
		characters => selectall_hashrows("SELECT *, p.name AS person_name, m.name AS movie_name FROM people p JOIN casts c ON (p.id = c.person_id) JOIN movies m ON (c.movie_id = m.id) WHERE c.role ILIKE ? ORDER BY m.date", "%$query%"),
		categories => selectall_hashrows("SELECT * FROM categories c WHERE name ILIKE ? ORDER BY c.name", "%$query%"),
	});

} else {
	#print "<pre>";
	#print "$_: $ENV{$_}\n" foreach (sort keys %ENV);
	#print "</pre>";
	error ("404 - Path $path unknown");
}
