package ST16;
use strict;
use warnings;

my %list=();
my $id=0;
my @menu=
(
	"Add movie",
	"Edit movie",
	"Erase movie",
	"Print list",
	"Save to file",
	"Read list from file",
	"Exit module"
);

my @menulinks=
(
	\&add,
	\&edit,
	\&erase,
	\&printlist,
	\&savefile,
	\&readfile,
);
sub st16
{
 
	while(1)
	{
		my $ch = menu();
		if(defined $menulinks[$ch])
		{	
			$menulinks[$ch]->();		
		}
		else
		{
			return;
		}
	}
}
sub menu
{
	my $i = 0;
	print "\n------------------------------\n";
	foreach my $s(@menu)
	{
		$i++;
		print "$i. $s\n";
	}
	print "------------------------------\n";
	my $ch = <STDIN>;
	return ($ch-1);
}
sub add
{
	print "title = ";
	my $title=<STDIN>;	
	print "country = ";
	my $country=<STDIN>;	
	print "year = ";
	my $year=<STDIN>;	
	print "mark = ";
	my $mark=<STDIN>;	
	my $movie={
		title => $title,
		country => $country,
		year => $year,
		mark => $mark};
	$list{$id}=$movie;
	$id++;
	return 1;
}
sub printlist
{
	#while ( my ($j, $i) = each(%list) ) {not sorted((
    for my $j (sort keys %list ) {
        my $i = $list{$j};
		print "\nMovie #$j\n$i->{title}$i->{country}$i->{year}$i->{mark}";
    }
	
	return 1;
}
sub edit
{	
	printlist();
	print "\nSelect ID to change";
	chomp(my $i=<STDIN>);
	print "title = ";
	my $title=<STDIN>;	
	print "country = ";
	my $country=<STDIN>;	
	print "year = ";
	my $year=<STDIN>;	
	print "mark = ";
	my $mark=<STDIN>;	
	my $movie={
		title => $title,
		country => $country,
		year => $year,
		mark => $mark};
	$list{$i}=$movie;
	return 1;
}
sub erase
{
	printlist();
	print "\nSelect ID to erase\n";
	chomp(my $i=<STDIN>);
	delete $list{$i};
	return 1;
}
sub savefile
{
	my %filehash;
	dbmopen(%filehash, "database", 0644);
	foreach my $j(keys %list)
	{
		my $i = $list{$j};
		my $text=$i->{title}.$i->{country}.$i->{year}.$i->{mark};
		print $text;
		$filehash{$j}=$text;
	}
	dbmclose(%filehash);
	return 1;
}
sub readfile
{
	my %filehash;
	dbmopen(%filehash, "database", 0644);
	%list =();
	$id=0;
	foreach my $j(keys %filehash)
	{
		my $i = $filehash{$j};
		print $i;
		my @strtoarr = split /\n/, $i;
		my $movie={
			title => "$strtoarr[0]\n",
			country => "$strtoarr[1]\n",
			year => "$strtoarr[2]\n",
			mark => "$strtoarr[3]\n",
		};
		$list{$id}=$movie;
		$id++;
	}
	dbmclose(%filehash);
	return 1;
}
return 1;