#!/usr/bin/perl

use strict;
binmode(STDOUT,':encoding(cp866):bytes');
use st01::st01;
use st02::st02;
use st05::st05;
use st08::st08;
use st09::st09;
use st10::st10;
use st13::st13;
use st12::st12;
use st15::st15;
use st16::st16;
use st17::st17;
use st21::st21;
use st22::st22;

my @MODULES = 
(
	\&ST01::st01,
	\&ST02::st02,
	\&ST05::st05,
	\&ST08::st08,
	\&ST09::st09,
	\&ST10::st10,
	\&ST12::st12,
	\&ST13::st13,
	\&ST15::st15,
	\&ST16::st16,
	\&ST17::st17,
	\&ST21::st21,
	\&ST22::st22,
);

my @NAMES = 
(
	"01. Abramov",
	"Student 02",
	"05. Girgushkina",
	"08. kuzznetsovva",
	"09. Kuzmin",
	"10. Kuklianov",
	"12. Kushnikov V.",
	"13. Mansurov",
	"15. Pridachin",
	"16. Samokhin",
	"17. Tikhonov R.",
	"21. Shilenkov",
	"22. ShishkinaViktoria"
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
