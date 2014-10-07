#!/usr/bin/perl

use strict;

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

print "Hello World!\n";

print "\n";