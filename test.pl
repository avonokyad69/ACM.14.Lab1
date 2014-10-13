#!/usr/bin/perl

use strict;
use st13::st13;

my @MODULES = 
(
	\&ST13::st13,
);

my @NAMES = 
(
	"Student 01",
	"Student 02",
	"Mansurov Alexander",
);

sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@NAMES)
	{
		$i++;
		print "$i. $s\n";
	}
	print "------------------------------\n";
	my $ch = <STDIN>;
	return ($ch-1);
}