#!/usr/bin/perl

use strict;
use st01::st01;
use st02::st02;
use st03::st03;
#так надо? что-то пока не очень понятно
#просто проверяю

my @MODULES = 
(
	\&ST01::st01,
	\&ST02::st02,
	\&ST03::st03,
);

my @NAMES = 
(
	"Student 01",
	"Student 02",
	"Student 03",
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

while(1)
{
	my $ch = menu();
	if(defined $MODULES[$ch])
	{
		print $NAMES[$ch]." launching...\n\n";
		$MODULES[$ch]->();
	}
	else
	{
		exit();
	}
}
