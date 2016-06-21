#!/usr/bin/perl

use strict;
use warnings;
use DBD::Pg;
use Text::CSV;

binmode STDIN, ':encoding(UTF-8)'; # read UTF-8 from STDIN

my $dbname = 'omdb';
my $tbl = shift || die "Syntax: $0 <table>";

my $csv = Text::CSV->new({ binary => 0, escape_char => '\\' })
	or die "" . Text::CSV->error_diag ();;

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname", '', '',
	{ AutoCommit => 0, RaiseError => 1, PrintError => 0 });
$dbh->do("COPY $tbl FROM STDIN");

<>; # skip header

my $n = 0;
while (my $row = $csv->getline (*STDIN)) {
	#print "@$row\n";
	map {
		if ($_ eq 'N') {
			$_ = '\N'; # \N -> NULL
		} else {
			s/^\s+//; s/\s+$//; s/\s+/ /g; # remove extra whitespace from fields
			s/\\/\\\\/g; # quote backslashes
		}
	} @$row;
	$dbh->pg_putcopydata (join ("\t", @$row) . "\n");
	$n++;
}

$dbh->pg_putcopyend();
$dbh->commit();

print "$tbl: $n rows\n";
